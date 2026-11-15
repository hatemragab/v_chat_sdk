// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../v_chat_message_page.dart';
import '../../../v_chat/v_app_alert.dart';
import '../../../v_chat/v_circle_avatar.dart';
import '../../../v_chat/v_safe_api_call.dart';
import '../../core/agora_user.dart';
import '../../core/call_state.dart';
import '../widgets/agora_video_layout.dart';
import '../widgets/call_actions_row.dart';

class VCallPage extends StatefulWidget {
  final VCallDto dto;

  const VCallPage({super.key, required this.dto});

  @override
  State<VCallPage> createState() => _VCallPageState();
}

class _VCallPageState extends State<VCallPage> {
  //rtc
  late final RtcEngine _agoraEngine;
  RtcEngineEventHandler? _agoraEventHandler;
  bool _agoraInitialized = false;
  bool _callEnded = false;

  //users
  final _users = <AgoraUser>{};

  //view
  late double _viewAspectRatio;

  final value = CallState();

  String get channelName => widget.dto.roomId;
  int? _currentUid;

  StreamSubscription? callStream;

  bool get _callerIsVideoEnable => widget.dto.isVideoEnable;

  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  Future<void> _initializeAgora() async {
    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      _viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      _viewAspectRatio = 2 / 3;
    } else {
      _viewAspectRatio = 3 / 2;
    }
    try {
      if (!await _initAgoraRtcEngine()) return;
      _addAgoraEventHandlers();

      final userToken = await VChatController.I.nativeApi.remote.calls
          .getAgoraAccess(channelName);
      await _agoraEngine.joinChannel(
        token: userToken,
        channelId: channelName,
        uid: 0,
        options: ChannelMediaOptions(
          publishMicrophoneTrack: true,
          publishCameraTrack: widget.dto.isVideoEnable,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      if (widget.dto.isCaller) _createCall();
      if (widget.dto.meetId != null) _acceptCall();
    } catch (err, trace) {
      debugPrint('Agora initialization failed: $err\n$trace');
      if (mounted) {
        VAppAlert.showSuccessSnackBar(
          msg: 'Unable to start the call: $err',
          context: context,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(_initializeAgora());
    _addListeners();
    unawaited(WakelockPlus.enable());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CupertinoPageScaffold(
        backgroundColor: Colors.black,
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          middle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VCircleAvatar(
                fullUrl: widget.dto.peerUser.userImages.chatImage,
                radius: 20,
              ),
              const SizedBox(width: 15),
              Text(
                widget.dto.peerUser.fullName,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (value.status == CallStatus.accepted)
                StreamBuilder<int>(
                  initialData: 0,
                  stream: stopWatchTimer.rawTime,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      StopWatchTimer.getDisplayTime(
                        snapshot.data!,
                        hours: false,
                        milliSecond: false,
                        minute: true,
                        second: true,
                      ).toString(),
                    );
                  },
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      final isPortrait = orientation == Orientation.portrait;
                      if (_users.isEmpty) {
                        return const SizedBox();
                      }
                      final nextAspectRatio = isPortrait ? 2 / 3 : 3 / 2;
                      if (_viewAspectRatio != nextAspectRatio) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _viewAspectRatio = nextAspectRatio);
                          }
                        });
                      }
                      final layoutViews = _createLayout(_users.length);
                      return AgoraVideoLayout(
                        users: _users,
                        views: layoutViews,
                        viewAspectRatio: _viewAspectRatio,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: 360,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CallActionButton(
                        icon: value.isVideoEnabled
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                        isEnabled: widget.dto.isVideoEnable,
                        onTap: widget.dto.isVideoEnable
                            ? _onToggleCamera
                            : null,
                      ),
                      CallActionButton(
                        icon: Icons.cameraswitch_rounded,
                        onTap: widget.dto.isVideoEnable
                            ? _onSwitchCamera
                            : null,
                        isEnabled: widget.dto.isVideoEnable,
                      ),
                      CallActionButton(
                        icon: value.isMicEnabled ? Icons.mic : Icons.mic_off,
                        isEnabled: true,
                        onTap: _onToggleMicrophone,
                      ),
                      CallActionButton(
                        icon: value.isSpeakerEnabled
                            ? CupertinoIcons.speaker_3
                            : CupertinoIcons.speaker_1,
                        onTap: _onToggleSpeaker,
                      ),
                      CallActionButton(
                        icon: Icons.call_end,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        radius: 30,
                        isEnabled: true,
                        backgroundColor: Colors.red,
                        iconSize: 28,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopWatchTimer.dispose();
    unawaited(WakelockPlus.disable());
    unawaited(callStream?.cancel());
    unawaited(_onCallEnd());
    super.dispose();
  }

  Future<void> _onCallEnd() async {
    if (_callEnded) return;
    _callEnded = true;
    if (_agoraInitialized) {
      final eventHandler = _agoraEventHandler;
      if (eventHandler != null) {
        _agoraEngine.unregisterEventHandler(eventHandler);
      }
      await _agoraEngine.leaveChannel();
      await _agoraEngine.release();
      _agoraInitialized = false;
    }
    await endCallApi();
  }

  Future<bool> _initAgoraRtcEngine() async {
    final appId = VChatController.I.vChatConfig.agoraAppId;
    if (appId == null || appId.isEmpty) {
      VAppAlert.showSuccessSnackBar(
        msg: 'Agora App Id is null please add it first in the configuration',
        context: context,
      );
      return false;
    }

    _agoraEngine = createAgoraRtcEngine();
    await _agoraEngine.initialize(RtcEngineContext(appId: appId));
    _agoraInitialized = true;
    await _agoraEngine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );
    await _agoraEngine.enableAudio();
    if (_callerIsVideoEnable) {
      await _agoraEngine.enableVideo();
      value.isSpeakerEnabled = true;
      value.isVideoEnabled = true;
    }
    await _agoraEngine.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await _agoraEngine.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );
    await _agoraEngine.muteLocalAudioStream(false);
    await _agoraEngine.setEnableSpeakerphone(_callerIsVideoEnable);
    await _agoraEngine.muteLocalVideoStream(!_callerIsVideoEnable);
    return true;
  }

  void _addAgoraEventHandlers() {
    _agoraEventHandler = RtcEngineEventHandler(
      onError: (code, message) {
        final info = 'LOG::onError: $code, $message';
        debugPrint(info);
      },
      onJoinChannelSuccess: (connection, elapsed) {
        if (!mounted) return;
        final uid = connection.localUid ?? 0;
        final info = 'LOG::onJoinChannel: $channelName, uid: $uid';
        debugPrint(info);
        setState(() {
          _currentUid = uid;
          _users.add(
            AgoraUser(
              uid: uid,
              isAudioEnabled: value.isMicEnabled,
              isVideoEnabled: value.isVideoEnabled,
              view: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _agoraEngine,
                  canvas: const VideoCanvas(
                    uid: 0,
                    renderMode: RenderModeType.renderModeHidden,
                  ),
                ),
              ),
            ),
          );
        });
      },
      onLeaveChannel: (connection, stats) {
        debugPrint('LOG::onLeaveChannel');
        if (mounted) setState(_users.clear);
      },
      onUserJoined: (connection, uid, elapsed) {
        if (!mounted) return;
        final info = 'LOG::userJoined: $uid';
        debugPrint(info);
        setState(
          () => _users.add(
            AgoraUser(
              uid: uid,
              isAudioEnabled: true,
              isVideoEnabled: widget.dto.isVideoEnable,
              view: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _agoraEngine,
                  canvas: VideoCanvas(
                    uid: uid,
                    renderMode: RenderModeType.renderModeHidden,
                  ),
                  connection: connection,
                ),
              ),
            ),
          ),
        );
      },
      onUserOffline: (connection, uid, reason) {
        if (!mounted) return;
        final info = 'LOG::userOffline: $uid';
        debugPrint(info);
        setState(() => _users.removeWhere((user) => user.uid == uid));
      },
      onRemoteVideoStateChanged: (connection, uid, state, reason, elapsed) {
        if (!mounted) return;
        final info = 'LOG::remoteVideoStateChanged: $uid $state $reason';
        debugPrint(info);
        for (AgoraUser user in _users) {
          if (user.uid == uid) {
            setState(
              () => user.isVideoEnabled =
                  state != RemoteVideoState.remoteVideoStateStopped,
            );
          }
        }
      },
      onRemoteAudioStateChanged: (connection, uid, state, reason, elapsed) {
        if (!mounted) return;
        final info = 'LOG::remoteAudioStateChanged: $uid $state $reason';
        debugPrint(info);
        for (AgoraUser user in _users) {
          if (user.uid == uid) {
            setState(
              () => user.isAudioEnabled =
                  state != RemoteAudioState.remoteAudioStateStopped,
            );
          }
        }
      },
    );
    _agoraEngine.registerEventHandler(_agoraEventHandler!);
  }

  List<int> _createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }
    return layout;
  }

  void _onToggleCamera() {
    setState(() {
      value.isVideoEnabled = !value.isVideoEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == _currentUid) {
          setState(() => user.isVideoEnabled = value.isVideoEnabled);
        }
      }
    });
    _agoraEngine.muteLocalVideoStream(!value.isVideoEnabled);
  }

  void _onToggleMicrophone() {
    setState(() {
      value.isMicEnabled = !value.isMicEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == _currentUid) {
          user.isAudioEnabled = value.isMicEnabled;
        }
      }
    });
    _agoraEngine.muteLocalAudioStream(!value.isMicEnabled);
  }

  void _onToggleSpeaker() {
    setState(() {
      value.isSpeakerEnabled = !value.isSpeakerEnabled;
    });
    _agoraEngine.setEnableSpeakerphone(value.isSpeakerEnabled);
  }

  void _onSwitchCamera() => _agoraEngine.switchCamera();

  void _createCall() async {
    try {
      value.meetId = await VChatController.I.nativeApi.remote.calls.createCall(
        roomId: widget.dto.roomId,
        withVideo: widget.dto.isVideoEnable,
      );
    } catch (err) {
      VAppAlert.showSuccessSnackBar(msg: err.toString(), context: context);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    }
  }

  ///call this once you want to end the call but it must be started
  Future endCallApi() async {
    final meetIdValue = widget.dto.meetId ?? value.meetId;
    if (meetIdValue == null) return;
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.endCallV2(meetIdValue);
      },
      onSuccess: (_) {},
      onError: (exception, trace) async {},
    );
  }

  void _addListeners() {
    callStream = VChatController.I.nativeApi.streams.callStream.listen((
      e,
    ) async {
      if (e is VCallAcceptedEvent) {
        value.status = CallStatus.accepted;
        setState(() {});
        stopWatchTimer.onStartTimer();
        return;
      }
      if (e is VCallTimeoutEvent) {
        value.status = CallStatus.timeout;
        setState(() {});
        Navigator.pop(context);
        return;
      }
      if (e is VCallEndedEvent) {
        value.status = CallStatus.callEnd;
        setState(() {});
        if (context.mounted) {
          Navigator.pop(context);
        }
        return;
      }
      if (e is VCallRejectedEvent) {
        value.status = CallStatus.rejected;
        setState(() {});
        Navigator.pop(context);
        return;
      }
    });
  }

  void _acceptCall() async {
    await VChatController.I.nativeApi.remote.calls.acceptCall(
      meetId: widget.dto.meetId!,
    );
    stopWatchTimer.onStartTimer();
    setState(() {
      value.status = CallStatus.accepted;
    });
  }
}
