import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';

import '../../../../models/vchat_message.dart';
import '../../../../services/vchat_app_service.dart';
import '../../controllers/message_controller.dart';

class MessageVoiceView extends GetView<MessageController> {
  final VchatMessage _message;
  final bool isSender;
  final myId =VChatAppService.to.vChatUser!.id;

  MessageVoiceView(this._message, {Key? key, required this.isSender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final att = _message.messageAttachment!;
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Obx(() {
                    final res = att.isVoicePlying.value;
                    if (res) {
                      // pause
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.pauseVoice(_message);
                            },
                            child: const Icon(
                              Icons.pause,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // play
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.find<MessageController>().playVoice(_message);
                            },
                            child: const Icon(
                              Icons.play_arrow,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                  Flexible(
                    child: SizedBox(
                      width: Get.width,
                      child: Obx(() {
                        final value =
                            att.currentPlayPosition.value.inMilliseconds;
                        return CupertinoSlider(
                          value: value.toDouble(),
                          min: 0.0,
                          max: att.maxDuration.value.inMilliseconds.toDouble(),
                          onChangeStart: (value) {
                            controller.pauseVoice(_message);
                          },
                          onChanged: (value) {
                            att.currentPlayPosition.value = Duration(
                              milliseconds: value.toInt(),
                            );
                          },
                          onChangeEnd: (value) {
                            controller.seekVoiceTo(_message, value);
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                child: att.fileDuration!.cap.height(.4),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
