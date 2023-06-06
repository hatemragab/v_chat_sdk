// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_web_rtc/src/core/enums.dart';

import '../../../v_chat_web_rtc.dart';
import '../../core/conditional_builder.dart';
import '../../core/v_caller_state.dart';
import '../widgets/call_fotter.dart';
import '../widgets/timer_widget.dart';
import '../widgets/user_icon_widget.dart';
import 'callee_controller.dart';

class VCalleePage extends StatefulWidget {
  final VNewCallModel model;
  final VCallLocalization localization;

  const VCalleePage({
    Key? key,
    required this.model,
    required this.localization,
  }) : super(key: key);

  @override
  State<VCalleePage> createState() => _VCalleePageState();
}

class _VCalleePageState extends State<VCalleePage> {
  late final CalleeController _controller;

  @override
  void initState() {
    _controller = CalleeController(
      widget.model,
      context,
      widget.localization,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: widget.localization.endToEndEncryption.cap.color(Colors.grey),
        ),
        body: SafeArea(
          child: ValueListenableBuilder<VCallerState>(
            valueListenable: _controller,
            builder: (_, value, __) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Visibility(
                    visible: widget.model.withVideo,
                    child: RTCVideoView(
                      _controller.remoteRenderer,
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
                      visible: widget.model.withVideo,
                      child: SizedBox(
                        height: 170,
                        width: 170,
                        child: RTCVideoView(
                          _controller.localRenderer,
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
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            UserIconWidget(
                              url: widget.model.identifierUser.baseUser
                                  .userImages.fullImage,
                              isVisible: !value.status.accepted ||
                                  !widget.model.withVideo,
                              userName:
                                  widget.model.identifierUser.baseUser.fullName,
                              subTitle: value.status.accepted
                                  ? TimerWidget(
                                      stopWatchTimer:
                                          _controller.stopWatchTimer,
                                    )
                                  : widget.localization
                                      .transCallStatus(value.status)
                                      .b1
                                      .color(Colors.white),
                            )
                          ],
                        ),
                      ),
                      VConditionalBuilder(
                        condition: value.status.ring,
                        thenBuilder: () => Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xff4f3434),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                PhosphorIcons.chat,
                                color: Colors.grey,
                                size: 35,
                              ),
                              InkWell(
                                onTap: _controller.acceptCall,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 55,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => _controller.onExit(context),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        elseBuilder: () => CallFotter(
                          onClose: () => _controller.onExit(context),
                        ),
                      ),
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
