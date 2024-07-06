// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../v_chat_message_page.dart';
import '../../../v_chat/v_app_alert.dart';
import '../../../v_chat/v_circle_avatar.dart';
import '../../../v_chat/v_safe_api_call.dart';
import '../../core/v_call_localization.dart';

class PickUp extends StatefulWidget {
  const PickUp({
    super.key,
    required this.callModel,
    required this.localization,
  });

  final VNewCallModel callModel;
  final VCallLocalization localization;

  @override
  State<PickUp> createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  StreamSubscription? subscription;
  final _ringtonePlayer = FlutterRingtonePlayer();

  @override
  void initState() {
    super.initState();
    _playRingtone();
    _addListeners();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  VCircleAvatar(
                    fullUrl: widget.callModel.peerUser.userImages.chatImage,
                    radius: 80,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    widget.callModel.peerUser.fullName,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.callModel.withVideo
                        ? widget.localization.incomingVideoCall
                        : widget.localization.incomingVoiceCall,
                    style: const TextStyle(
                      color: CupertinoColors.systemGreen,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.all(15.0),
                        color: CupertinoColors.systemGreen,
                        borderRadius: BorderRadius.circular(50.0),
                        onPressed: _acceptCall,
                        child: const Icon(CupertinoIcons.phone_circle_fill,
                            color: CupertinoColors.white, size: 35),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.all(15.0),
                        color: CupertinoColors.systemRed,
                        borderRadius: BorderRadius.circular(50.0),
                        onPressed: () => _rejectCall(context),
                        child: const Icon(CupertinoIcons.phone_down_circle_fill,
                            color: CupertinoColors.white, size: 35),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestMicrophonePermission() async {
    final res = await [Permission.microphone].request();
    if (res[Permission.microphone] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> _requestCameraPermission() async {
    final res = await [Permission.microphone].request();
    if (res[Permission.camera] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  void _acceptCall() async {
    if (widget.callModel.withVideo) {
      if (!await _requestMicrophonePermission() &&
          !await _requestCameraPermission() &&
          !VPlatforms.isWeb) {
        VAppAlert.showSuccessSnackBar(
          msg: widget.localization.microphoneAndCameraPermissionMustBeAccepted,
          context: context,
        );
        return;
      }
    } else {
      if (!await _requestMicrophonePermission() && !VPlatforms.isWeb) {
        VAppAlert.showSuccessSnackBar(
            msg: widget.localization.microphonePermissionMustBeAccepted,
            context: context);
        return;
      }
    }
    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 100));
    VChatController.I.vNavigator.callNavigator?.toCall(
      VChatController.I.navigationContext,
      VCallDto(
        isVideoEnable: widget.callModel.withVideo,
        roomId: widget.callModel.roomId,
        peerUser: widget.callModel.peerUser,
        isCaller: false,
        meetId: widget.callModel.meetId,
      ),
    );
  }

  void _rejectCall(BuildContext context) async {
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls
            .rejectCall(widget.callModel.meetId);
      },
      onSuccess: (_) {},
      onError: (exception, trace) async {
        VAppAlert.showSuccessSnackBar(msg: exception, context: context);
      },
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _stopRingtone();
    subscription?.cancel();
    super.dispose();
  }

  void _playRingtone() async {
    if (VPlatforms.isMobile) {
      await _ringtonePlayer.playRingtone(
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );
    }
  }

  void _stopRingtone() async {
    if (VPlatforms.isMobile) {
      await _ringtonePlayer.stop();
    }
  }

  void _addListeners() {
    subscription = VChatController.I.nativeApi.streams.callStream.listen(
      (e) async {
        if (e is VCallCanceledEvent) {
          Navigator.of(context).pop();
          return;
        }

        if (e is VCallTimeoutEvent) {
          Navigator.of(context).pop();
          return;
        }
      },
    );
  }
}
