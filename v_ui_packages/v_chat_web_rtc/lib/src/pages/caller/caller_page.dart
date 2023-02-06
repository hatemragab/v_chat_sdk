library caller_page;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_web_rtc/src/core/enums.dart';
import 'package:v_chat_web_rtc/src/core/rtc_helper.dart';
import 'package:v_chat_web_rtc/src/core/v_caller_state.dart';

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
      onWillPop: () async => _controller.onExit(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Caller page"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<VCallerState>(
              valueListenable: _controller,
              builder: (_, value, __) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 300,
                        child: Row(
                          children: [
                            Expanded(
                              child: RTCVideoView(
                                _controller._localRenderer,
                                placeholderBuilder: (context) => Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RTCVideoView(
                                _controller._remoteRenderer,
                                placeholderBuilder: (context) => Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text("Call status"),
                        subtitle: _controller.value.status.name.text,
                      ),
                      ListTile(
                        title: const Text("Call Timer"),
                        subtitle: _controller.value.time.toString().text,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Visibility(
                        visible: _controller.meetId != null,
                        child: ElevatedButton(
                          onPressed: _controller.cancelCall,
                          child: "cancel".text,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: _controller.meetId != null &&
                            _controller.value.status == CallStatus.accepted,
                        child: ElevatedButton(
                          onPressed: _controller.cancelCall,
                          child: "End call".text,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
