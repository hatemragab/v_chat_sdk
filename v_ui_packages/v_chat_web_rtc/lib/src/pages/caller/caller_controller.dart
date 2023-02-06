part of '../caller/caller_page.dart';

class _CallerController extends ValueNotifier<VCallerState> {
  final VCallerDto callDto;
  String? meetId;
  late final StreamSubscription subscription;
  final BuildContext context;
  Timer? _timer;
  RTCPeerConnection? _peerConnection;

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
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    await _initLocalMediaRender();
    await _createPeerConnection();
    // await _createOffer();
  }

  Future<void> _initLocalMediaRender() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };
    final stream = await navigator.mediaDevices.getUserMedia(
      constraints,
    );
    _localRenderer.srcObject = stream;
    _localMediaStream = stream;
    notifyListeners();
  }

  Future _createPeerConnection() async {
    _peerConnection = await createPeerConnection(
      RtcHelper.iceServers,
      RtcHelper.offerSdpConstraints,
    );
    _peerConnection!.addStream(_localMediaStream!);
    _peerConnection!.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
      notifyListeners();
    };
  }

  Future _createOffer() async {
    final description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    final session = parse(description.sdp!);
    _peerConnection!.setLocalDescription(description);
    await _requestCall(session);
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
        _backAfterSecond();
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
        _backAfterSecond();
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
        return true;
      }
      if (value.status == CallStatus.accepted) {
        await endCall();
      }
      return true;
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
    _timer?.cancel();
    _timer = Timer(
      const Duration(seconds: 1),
      () {
        value.time = Duration(
          seconds: value.time.inSeconds + 1,
        );
        notifyListeners();
      },
    );
  }

  Future<void> _handleAcceptCall(Map<String, dynamic> data) async {
    final answer = data['answer'] as Map<String, dynamic>;
    final ice = data['ice'] as Map<String, dynamic>;
    await _setRemote(answer);
    await _setIce(ice);
  }

  Future _setRemote(Map<String, dynamic> session) async {
    String sdp = write(session, null);
    RTCSessionDescription description = RTCSessionDescription(
      sdp,
      'answer',
    );
    await _peerConnection!.setRemoteDescription(description);
  }

  Future _setIce(Map<String, dynamic> ice) async {
    final candidate = RTCIceCandidate(
      ice['candidate'] as String,
      ice['sdpMid'] as String,
      ice['sdpMLineIndex'] as int,
    );
    await _peerConnection!.addCandidate(candidate);
  }

  void close() {
    subscription.cancel();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localMediaStream?.dispose();
    _peerConnection?.dispose();
    _timer?.cancel();
  }
}
