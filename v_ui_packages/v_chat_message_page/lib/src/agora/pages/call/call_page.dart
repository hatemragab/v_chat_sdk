// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

// import 'package:wakelock/wakelock.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
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

  const VCallPage({
    super.key,
    required this.dto,
  });

  @override
  State<VCallPage> createState() => _VCallPageState();
}

class _VCallPageState extends State<VCallPage> {
  //rtc
  late final RtcEngine _agoraEngine;

  //users
  final _users = <AgoraUser>{};

  //view
  late double _viewAspectRatio;

  final value = CallState();

  String get channelName => widget.dto.roomId;
  int? _currentUid;

  StreamSubscription? callStream;

  bool get _callerIsVideoEnable => widget.dto.isVideoEnable;

  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  Future<void> _initializeAgora() async {
    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      _viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      _viewAspectRatio = 2 / 3;
    } else {
      _viewAspectRatio = 3 / 2;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    final options = ChannelMediaOptions(
      publishLocalAudio: true,
      publishLocalVideo: widget.dto.isVideoEnable,
    );
    // Join the channel
    final userToken = await VChatController.I.nativeApi.remote.calls
        .getAgoraAccess(channelName);
    await _agoraEngine.joinChannel(
      userToken,
      channelName,
      null,
      0,
      options,
    );
    if (widget.dto.isCaller) _createCall();
    if (widget.dto.meetId != null) _acceptCall();
  }

  @override
  void initState() {
    _initializeAgora();
    _addListeners();
    unawaited(WakelockPlus.enable());
    super.initState();
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
              const SizedBox(
                width: 15,
              ),
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
                    return Text(StopWatchTimer.getDisplayTime(
                      snapshot.data!,
                      hours: false,
                      milliSecond: false,
                      minute: true,
                      second: true,
                    ).toString());
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
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => setState(() =>
                            _viewAspectRatio = isPortrait ? 2 / 3 : 3 / 2),
                      );
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
                        onTap:
                            widget.dto.isVideoEnable ? _onToggleCamera : null,
                      ),
                      CallActionButton(
                        icon: Icons.cameraswitch_rounded,
                        onTap:
                            widget.dto.isVideoEnable ? _onSwitchCamera : null,
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
    WakelockPlus.disable();
    callStream?.cancel();
    _onCallEnd();
    super.dispose();
  }

  Future<void> _onCallEnd() async {
    await _agoraEngine.leaveChannel();
    await _agoraEngine.destroy();
    endCallApi();
  }

  Future<void> _initAgoraRtcEngine() async {
    if (VChatController.I.vChatConfig.agoraAppId == null) {
      VAppAlert.showSuccessSnackBar(
          msg: "Agora App Id is null please add it first in the configuration",
          context: context);
      return;
    }
    try {
      _agoraEngine = await RtcEngine.create(
          VChatController.I.vChatConfig.agoraAppId ?? '');
    } catch (err) {
      VAppAlert.showSuccessSnackBar(
          msg: "Agora Error is $err", context: context);
    }

    final configuration = VideoEncoderConfiguration();
    configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    await _agoraEngine.setVideoEncoderConfiguration(configuration);
    await _agoraEngine.enableAudio();
    if (_callerIsVideoEnable) {
      await _agoraEngine.enableVideo();
      value.isSpeakerEnabled = true;
      value.isVideoEnabled = true;
    }
    await _agoraEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _agoraEngine.setClientRole(ClientRole.Broadcaster);
    await _agoraEngine.muteLocalAudioStream(false);
    await _agoraEngine.setEnableSpeakerphone(_callerIsVideoEnable);
    await _agoraEngine.muteLocalVideoStream(!_callerIsVideoEnable);
  }

  Future<void> _addAgoraEventHandlers() async {
    _agoraEngine.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          final info = 'LOG::onError: $code';
          debugPrint(info);
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          final info = 'LOG::onJoinChannel: $channel, uid: $uid';
          debugPrint(info);
          setState(() {
            _currentUid = uid;
            _users.add(
              AgoraUser(
                uid: uid,
                isAudioEnabled: value.isMicEnabled,
                isVideoEnabled: value.isVideoEnabled,
                view: const rtc_local_view.SurfaceView(),
              ),
            );
          });
        },
        firstLocalAudioFrame: (elapsed) {
          final info = 'LOG::firstLocalAudio: $elapsed';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == _currentUid) {
              setState(() => user.isAudioEnabled = value.isMicEnabled);
            }
          }
        },
        firstLocalVideoFrame: (width, height, elapsed) {
          debugPrint('LOG::firstLocalVideo');
          for (AgoraUser user in _users) {
            if (user.uid == _currentUid) {
              setState(
                () => user
                  ..isVideoEnabled = value.isVideoEnabled
                  ..view = const rtc_local_view.SurfaceView(
                    renderMode: VideoRenderMode.Hidden,
                  ),
              );
            }
          }
        },
        leaveChannel: (stats) {
          debugPrint('LOG::onLeaveChannel');
          setState(() => _users.clear());
        },
        userJoined: (uid, elapsed) {
          final info = 'LOG::userJoined: $uid';
          debugPrint(info);
          setState(
            () => _users.add(
              AgoraUser(
                uid: uid,
                view: rtc_remote_view.SurfaceView(
                  channelId: channelName,
                  uid: uid,
                ),
              ),
            ),
          );
        },
        userOffline: (uid, elapsed) {
          final info = 'LOG::userOffline: $uid';
          debugPrint(info);
          AgoraUser? userToRemove;
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              userToRemove = user;
            }
          }
          setState(() => _users.remove(userToRemove));
        },
        firstRemoteAudioFrame: (uid, elapsed) {
          final info = 'LOG::firstRemoteAudio: $uid';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(() => user.isAudioEnabled = true);
            }
          }
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {
          final info = 'LOG::firstRemoteVideo: $uid ${width}x $height';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(
                () => user
                  ..isVideoEnabled = true
                  ..view = rtc_remote_view.SurfaceView(
                    channelId: channelName,
                    uid: uid,
                  ),
              );
            }
          }
        },
        remoteVideoStateChanged: (uid, state, reason, elapsed) {
          final info = 'LOG::remoteVideoStateChanged: $uid $state $reason';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(() =>
                  user.isVideoEnabled = state != VideoRemoteState.Stopped);
            }
          }
        },
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          final info = 'LOG::remoteAudioStateChanged: $uid $state $reason';
          debugPrint(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(() =>
                  user.isAudioEnabled = state != AudioRemoteState.Stopped);
            }
          }
        },
      ),
    );
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
    callStream = VChatController.I.nativeApi.streams.callStream.listen(
      (e) async {
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
      },
    );
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
