import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/v_chat_extention.dart';

import '../../../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../../../../utils/custom_widgets/rounded_container.dart';
import '../../../../../utils/helpers/helpers.dart';

class MessageRecordView extends StatefulWidget {
  final Function(String path, String duration) onReceiveRecord;
  final Function() onCancel;

  const MessageRecordView(
      {Key? key, required this.onReceiveRecord, required this.onCancel})
      : super(key: key);

  @override
  State<MessageRecordView> createState() => _MessageRecordViewState();
}

class _MessageRecordViewState extends State<MessageRecordView> {
  final recorder = Record();
  String recordTime = "00:00";
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) {
      setState(() {
        recordTime = StopWatchTimer.getDisplayTime(
          value,
          hours: false,
          milliSecond: false,
        );
      });
    });
    startRecord();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: widget.onCancel,
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 35,
                ),
              ),
              InkWell(
                child: recordTime.h6,
              ),
              InkWell(
                onTap: stopRecord,
                child: RoundedContainer(
                  boxShape: BoxShape.circle,
                  color: VChatAppService.instance.vcBuilder
                      .sendButtonColor(context, context.isDark),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startRecord() async {
    if (await recorder.hasPermission()) {
      try {
        if (Platform.isIOS) {
          await recorder.start(
            bitRate: 75000,
            encoder: AudioEncoder.AAC_HE,
          );
        } else {
          await recorder.start(
            encoder: AudioEncoder.AAC_HE,
            bitRate: 40000,
            //samplingRate: 64100.0,
          );
        }

        bool isRecording = await recorder.isRecording();
        if (isRecording) {
          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
        }
      } catch (err) {
        Helpers.vlog(err.toString());
        CustomAlert.customAlertDialog(
            context: context,
            errorMessage:
                "record not supported on emulator run on real device !");
        widget.onCancel();
        rethrow;
      }
    }
  }

  void stopRecord() async {
    final recorderPath = await recorder.stop();
    final uri = Uri.parse(recorderPath!);
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    widget.onReceiveRecord(uri.path, recordTime);
  }
}
