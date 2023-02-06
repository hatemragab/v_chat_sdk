import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_web_rtc/src/core/enums.dart';

import '../../core/v_caller_state.dart';
import 'callee_controller.dart';

class VCalleePage extends StatefulWidget {
  final VNewCallModel model;

  const VCalleePage({
    Key? key,
    required this.model,
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
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _controller.onExit(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("is video ${widget.model.withVideo}"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<VCallerState>(
              valueListenable: _controller,
              builder: (_, value, __) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: Row(
                          children: [
                            Expanded(
                              child: RTCVideoView(
                                _controller.localRenderer,
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
                                _controller.remoteRenderer,
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
                      ElevatedButton(
                        onPressed: _controller.rejectCall,
                        child: "Reject".text,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _controller.acceptCall,
                        child: "Accept call".text,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: _controller.value.status == CallStatus.accepted,
                        child: ElevatedButton(
                          onPressed: _controller.endCall,
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
