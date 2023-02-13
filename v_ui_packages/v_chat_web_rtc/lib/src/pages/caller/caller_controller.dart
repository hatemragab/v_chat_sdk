part of '../caller/caller_page.dart';

class _CallerController extends ValueNotifier<VCallerState> {
  final VCallerDto callDto;
  String? meetId;
  late final StreamSubscription subscription;
  final BuildContext context;
  RTCPeerConnection? _peerConnection;

  final _iceCandidates = <RTCIceCandidate>[];
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  /// ---------- webrtc -------------
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localMediaStream;

  _CallerController(
    this.callDto,
    this.context,
  ) : super(VCallerState()) {
    _addListeners();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await _initLocalMediaRender();
    await _createPeerConnection();
    await _createOffer();
  }

  Future<void> _initLocalMediaRender() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': callDto.isVideoEnable
          ? {
              'facingMode': 'user',
            }
          : false,
    };
    _localMediaStream = await navigator.mediaDevices.getUserMedia(
      constraints,
    );
    _localRenderer.srcObject = _localMediaStream;
    notifyListeners();
  }

  void _emitIce(RTCIceCandidate candidate) {
    if (meetId == null) return;
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Caller _emitIce",
        desc: jsonEncode({
          "sdpMid": candidate.sdpMid as String,
          "sdpMLineIndex": candidate.sdpMLineIndex,
          "candidate": candidate.candidate,
        }),
      ),
    );
    VChatController.I.nativeApi.remote.socketIo.emitRtcIce(
      candidate.toMap(),
      meetId!,
    );
  }

  Future _createPeerConnection() async {
    _peerConnection = await createPeerConnection(
      RtcHelper.iceServers,
      RtcHelper.offerSdpConstraints,
    );
    _peerConnection!.onIceCandidate = (e) {
      if (e.candidate != null) {
        // _emitIce(e);
        _iceCandidates.add(e);
      }
    };
    _peerConnection!.addStream(_localMediaStream!);
    _peerConnection!.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
      notifyListeners();
    };
  }

  Future _createOffer() async {
    final offer = await _peerConnection!.createOffer(
      {
        'offerToReceiveVideo': 1,
        'offerToReceiveAudio': 1,
      },
    );
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Caller create offer",
        desc: jsonEncode({
          "type": offer.type!,
          "sdp": parse(offer.sdp!),
        }),
      ),
    );
    await _peerConnection!.setLocalDescription(offer);
    // if (_iceCandidates.isEmpty) {
    //   await Future.delayed(Duration(milliseconds: 400));
    // }
    await _requestCall({
      "sdp": parse(offer.sdp!),
      "type": offer.type!,
      // "ice": _iceCandidates.map((e) => e.toMap()).toList(),
    });
  }

// end connections apis ----------------------------------------
  Future _requestCall(Map<String, dynamic> offerPayload) async {
    await vSafeApiCall<String>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.createCall(
          withVideo: callDto.isVideoEnable,
          payload: offerPayload,
          roomId: callDto.roomId,
        );
      },
      onSuccess: (meetId) {
        this.meetId = meetId;
        value.status = CallStatus.ring;
        notifyListeners();
      },
      onError: (exception, trace) async {
        value.status = CallStatus.busy;
        notifyListeners();
        _backAfterSecond();
        print(exception);
      },
    );
  }

  Future endCall() async {
    if (meetId == null) return;
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.endCall(meetId!);
      },
      onSuccess: (_) {
        value.status = CallStatus.callEnd;
        notifyListeners();
      },
      onError: (exception, trace) async {
        VAppAlert.showErrorSnackBar(msg: exception, context: context);
      },
    );
  }

  Future cancelCall() async {
    if (meetId == null) return;
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.cancelCall(meetId!);
      },
      onSuccess: (_) {
        value.status = CallStatus.callEnd;
        notifyListeners();
      },
      onError: (exception, trace) async {
        VAppAlert.showErrorSnackBar(msg: exception, context: context);
      },
    );
  }

  void _backAfterSecond() async {
    await Future.delayed(const Duration(seconds: 1));
    context.pop();
  }

  Future<bool> onExit(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Exit call",
      content: "Are you sure to end the call ?",
    );
    if (res == 1) {
      if (value.status == CallStatus.ring) {
        await cancelCall();
      }
      if (value.status == CallStatus.accepted) {
        await endCall();
      }
      _backAfterSecond();
    }
    return false;
  }

  void _addListeners() {
    subscription = VEventBusSingleton.vEventBus.on<VCallEvents>().listen(
      (e) async {
        if (e is VCallEndedEvent) {
          value.status = CallStatus.callEnd;
          notifyListeners();
          _backAfterSecond();
          return;
        }
        if (e is VCallTimeoutEvent) {
          value.status = CallStatus.timeout;
          notifyListeners();
          _backAfterSecond();
          return;
        }
        if (e is VCallRejectedEvent) {
          value.status = CallStatus.rejected;
          notifyListeners();
          _backAfterSecond();
          return;
        }
        if (e is VOnRtcIceEvent) {
          await _setIce(e.data);
          return;
        }
        if (e is VCallAcceptedEvent) {
          value.status = CallStatus.accepted;
          await _handleAcceptCall(e.data.peerAnswer);
          notifyListeners();
          _initTimer();
          return;
        }
      },
    );
  }

  void _initTimer() {
    stopWatchTimer.onStartTimer();
  }

  Future<void> _handleAcceptCall(Map<String, dynamic> data) async {
    final answer = data['answer'] as Map<String, dynamic>;
    // final ice = (data['ice'] as List).cast<Map<String, dynamic>>();
    await _setRemote(answer);
     _emitIce(_iceCandidates.last);
  }

  Future _setRemote(Map<String, dynamic> session) async {
    RTCSessionDescription description = RTCSessionDescription(
      write(session['sdp'] as Map<String, dynamic>, null),
      session['type'] as String,
    );
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Caller _setRemote",
        desc: jsonEncode({
          "type": session['type'],
          "sdp": write(session['sdp'] as Map<String, dynamic>, null),
        }),
      ),
    );
    await _peerConnection!.setRemoteDescription(description);
  }

  Future _setIce(Map<String, dynamic> ice) async {
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Caller _setIce",
        desc: jsonEncode({
          "sdpMid": ice['sdpMid'] as String,
          "sdpMLineIndex": ice['sdpMLineIndex'] as int,
          "candidate": ice['candidate'] as String,
        }),
      ),
    );
    final candidate = RTCIceCandidate(
      ice['candidate'] as String,
      ice['sdpMid'] as String,
      ice['sdpMLineIndex'] as int,
    );
    print("caller _setIce $ice");
    await _peerConnection!.addCandidate(candidate);
  }

  void close() {
    subscription.cancel();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localMediaStream?.dispose();
    _peerConnection?.dispose();
    stopWatchTimer.dispose();
  }
}
