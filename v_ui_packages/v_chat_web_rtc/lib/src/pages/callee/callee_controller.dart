import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_web_rtc.dart';
import '../../core/enums.dart';
import '../../core/rtc_helper.dart';
import '../../core/v_caller_state.dart';

class CalleeController extends ValueNotifier<VCallerState> {
  final BuildContext context;

  final VNewCallModel callModel;
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  String get meetId => callModel.meetId;
  late final StreamSubscription subscription;
  RTCPeerConnection? _peerConnection;

  final _iceCandidates = <RTCIceCandidate>[];
  bool isPeerInit = false;

  /// ---------- webrtc -------------
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  MediaStream? _localMediaStream;

  CalleeController(
    this.callModel,
    this.context,
  ) : super(VCallerState(status: CallStatus.ring)) {
    _addListeners();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    await _initLocalMediaRender();
    await _createPeerConnection();
  }

  void close() {
    subscription.cancel();
    localRenderer.dispose();
    remoteRenderer.dispose();
    _localMediaStream?.dispose();
    _peerConnection?.dispose();
    stopWatchTimer.dispose();
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
        if (e is VCallCanceledEvent) {
          value.status = CallStatus.callEnd;
          notifyListeners();
          _backAfterSecond();
          return;
        }
        if (e is VOnRtcIceEvent) {
          await _setIce(e.data);
          return;
        }

        if (e is VCallTimeoutEvent) {
          value.status = CallStatus.timeout;
          notifyListeners();
          _backAfterSecond();
          return;
        }
      },
    );
  }

  void _initTimer() {
    stopWatchTimer.onStartTimer();
  }

  void _backAfterSecond() async {
    await Future.delayed(const Duration(seconds: 1));
    context.pop();
  }

  Future _setRemote(Map<String, dynamic> session) async {
    // final sdp = write(session['offer'] as Map<String, dynamic>, null);
    // final ices = (session['ice'] as List).cast<Map<String, dynamic>>();
    // await _setIce(ices);
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Callee _setRemote",
        desc: jsonEncode({
          "type": session['type'],
          "sdp": write(session['sdp'] as Map<String, dynamic>, null),
        }),
      ),
    );
    final description = RTCSessionDescription(
      write(session['sdp'] as Map<String, dynamic>, null),
      session['type'] as String,
    );
    await _peerConnection!.setRemoteDescription(description);
  }

  void _emitIce(RTCIceCandidate candidate) {
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Callee _emitIce",
        desc: jsonEncode({
          "sdpMid": candidate.sdpMid as String,
          "sdpMLineIndex": candidate.sdpMLineIndex,
          "candidate": candidate.candidate,
        }),
      ),
    );
    VChatController.I.nativeApi.remote.socketIo.emitRtcIce(
      candidate.toMap(),
      callModel.meetId,
    );
  }

  Future _setIce(Map<String, dynamic> ice) async {
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Callee _setIce",
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
    print("callee _setIce $ice");
    await _peerConnection!.addCandidate(candidate);
  }

  Future<void> acceptCall() async {
    value.status = CallStatus.connecting;
    notifyListeners();
    if (isPeerInit == false) {
      await Future.delayed(Duration(seconds: 1));
    }
    await _setRemote(callModel.payload);
    final answer = await _createAnswer();
    // if (_iceCandidates.isEmpty) {
    //   await Future.delayed(const Duration(milliseconds: 700));
    // }
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.acceptCall(
          meetId: meetId,
          answerPayload: {
            // "ice": _iceCandidates.map((e) => e.toMap()).toList(),
            "answer": answer,
          },
        );
      },
      onSuccess: (_) async {
        await Future.delayed(Duration(seconds: 1));
        value.status = CallStatus.accepted;
        notifyListeners();
        _emitIce(_iceCandidates.last);
        _initTimer();
      },
      onError: (exception, trace) async {
        // VAppAlert.showErrorSnackBar(msg: exception, context: context);
      },
    );
  }

  Future _createPeerConnection() async {
    _peerConnection = await createPeerConnection(
      RtcHelper.iceServers,
      RtcHelper.offerSdpConstraints,
    );
    _peerConnection!.addStream(_localMediaStream!);
    _peerConnection!.onIceCandidate = (e) {
      if (e.candidate != null) {
        // _emitIce(e);
        _iceCandidates.add(e);
      }
    };
    _peerConnection!.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
      notifyListeners();
    };
    isPeerInit = true;
  }

  Future<Map<String, dynamic>> _createAnswer() async {
    final answer = await _peerConnection!.createAnswer(
      {
        'offerToReceiveVideo': 1,
        'offerToReceiveAudio': 1,
      },
    );
    vRtcLoggerStream.add(
      VRtcAppLog(
        title: "Callee _createAnswer",
        desc: jsonEncode({
          "sdp": parse(answer.sdp!),
          "type": answer.type,
        }),
      ),
    );
    await _peerConnection!.setLocalDescription(answer);
    return {
      "sdp": parse(answer.sdp!),
      "type": answer.type,
    };
  }

  Future<void> _initLocalMediaRender() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': callModel.withVideo
          ? {
              'facingMode': 'user',
            }
          : false,
    };
    _localMediaStream = await navigator.mediaDevices.getUserMedia(
      constraints,
    );
    localRenderer.srcObject = _localMediaStream;
    notifyListeners();
  }

  Future rejectCall() async {
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.rejectCall(meetId);
      },
      onSuccess: (_) {
        value.status = CallStatus.rejected;
        notifyListeners();
      },
      onError: (exception, trace) async {
        // VAppAlert.showErrorSnackBar(msg: exception, context: context);
      },
    );
  }

  Future endCall() async {
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.endCall(meetId);
      },
      onSuccess: (_) {
        value.status = CallStatus.callEnd;
        notifyListeners();
      },
      onError: (exception, trace) async {
        //VAppAlert.showErrorSnackBar(msg: exception, context: context);
      },
    );
  }

  Future<bool> onExit(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: VTrans.labelsOf(context).exitFromTheCall,
      content: VTrans.labelsOf(context).areYouSureToEndTheCall,
    );
    if (res == 1) {
      if (value.status == CallStatus.accepted) {
        await endCall();
      }
      if (value.status == CallStatus.ring) {
        await rejectCall();
      }
      _backAfterSecond();
    }
    return false;
  }

// Future<RTCIceCandidate> _getIce() async {
//   return retry<RTCIceCandidate>(
//     () => _iceCandidates.first,
//     maxAttempts: 10,
//     retryIf: (p0) => _iceCandidates.isEmpty,
//   );
// }
}
