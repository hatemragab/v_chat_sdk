library caller_page;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_web_rtc/src/core/enums.dart';
import 'package:v_chat_web_rtc/src/core/rtc_helper.dart';
import 'package:v_chat_web_rtc/src/core/v_caller_state.dart';

import '../widgets/call_fotter.dart';
import '../widgets/timer_widget.dart';
import '../widgets/user_icon_widget.dart';

part 'caller_controller.dart';

class VCallerPage extends StatefulWidget {
  final VCallerDto dto;

  const VCallerPage({
    Key? key,
    required this.dto,
  }) : super(key: key);

  @override
  State<VCallerPage> createState() => _VCallerPageState();
}

class _VCallerPageState extends State<VCallerPage> {
  late final _CallerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _CallerController(
      widget.dto,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder<VCallerState>(
            valueListenable: _controller,
            builder: (_, value, __) {
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Visibility(
                    visible: widget.dto.isVideoEnable,
                    child: RTCVideoView(
                      _controller._remoteRenderer,
                      placeholderBuilder: (context) => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 100,
                    end: 1,
                    child: Visibility(
                      visible: widget.dto.isVideoEnable,
                      child: SizedBox(
                        height: 170,
                        width: 170,
                        child: RTCVideoView(
                          _controller._localRenderer,
                          placeholderBuilder: (context) => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_clock_outlined,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                "End-to-end encryption".b2.color(Colors.grey)
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            UserIconWidget(
                              url: widget.dto.peerImage,
                              isVisible: !value.status.accepted ||
                                  !widget.dto.isVideoEnable,
                              userName: widget.dto.peerName,
                              subTitle: value.status.accepted
                                  ? TimerWidget(
                                      stopWatchTimer:
                                          _controller.stopWatchTimer,
                                    )
                                  : value.status.name.b1,
                            )
                          ],
                        ),
                      ),
                      CallFotter(
                        onClose: () => _controller.onExit(context),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
