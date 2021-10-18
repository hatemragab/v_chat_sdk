import 'dart:convert';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import '../../../enums/load_more_type.dart';
import '../../../models/v_chat_message.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/v_chat_app_service.dart';
import '../../../utils/api_utils/server_config.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../room/controllers/rooms_controller.dart';
import '../providers/message_provider.dart';
import 'send_message_controller.dart';

class MessageController extends GetxController {
  static final _roomController = Get.find<RoomController>();
  final currentRoomId = Get.find<RoomController>().currentRoomId!;
  final _apiProvider = Get.find<MessageProvider>();
  final myModel = VChatAppService.to.vChatUser;
  final scrollController = ScrollController();
  final Rx<LoadMoreStatus> loadingStatus = LoadMoreStatus.loaded.obs;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final isRecordWidgetEnable = false.obs;
  final recordTime = "00:00".obs;
  final messagesList = <VChatMessage>[].obs;
  String? recordPath;
  final audioPlayer = AudioPlayer();
  VChatMessage? currentVoicePlayer;
  late Socket _socket;
  final isLastMessageSeen = false.obs;
  final localStorageService = Get.find<LocalStorageService>();

  final recorder = Record();

  @override
  void onInit() {
    super.onInit();
    getRoomMessages();
    _connectMessageSocket();
    final currentRoom = Get.find<RoomController>()
        .rooms
        .firstWhere((element) => element.id == currentRoomId);

    if (currentRoom.lastMessageSeenBy.length == 2) {
      if (currentRoom.lastMessage.senderId == myModel!.id) {
        isLastMessageSeen.value = true;
      } else {
        isLastMessageSeen.value = false;
      }
    } else {
      isLastMessageSeen.value = false;
    }

    scrollController.addListener(_scrollListener);
    setAudioPlayerListeners();
  }

  void offAllListeners() {
    _socket.off("new_message");
    _socket.off("all_messages");
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<NotificationService>().cancelAll();
    _stopWatchTimer.rawTime.listen((value) {
      recordTime.value = StopWatchTimer.getDisplayTime(
        value,
        hours: false,
        milliSecond: false,
      );
    });
  }

  void getRoomMessages() async {
    final x = await localStorageService.getRoomMessages(currentRoomId);
    messagesList.assignAll(x);
  }

  @override
  void onClose() {
    try {
      _socket.disconnect();
      _socket.dispose();
      _roomController.currentRoomId = null;
      scrollController.dispose();
      _stopWatchTimer.dispose();
      if (currentVoicePlayer != null) {
        currentVoicePlayer!.messageAttachment!.isVoicePlying.value = false;
        currentVoicePlayer!.messageAttachment!.currentPlayPosition.value =
            Duration.zero;
        audioPlayer.stop();
      }
    } catch (err) {
      log(err.toString());
    } finally {
      super.onClose();
    }
  }

  void loadMoreMessages() async {
    loadingStatus.value = LoadMoreStatus.loading;
    try {
      final loadedMessages = await _apiProvider.loadMoreMessages(
        currentRoomId,
        messagesList.last.id.toString(),
      );
      messagesList.addAll(loadedMessages);
      if (loadedMessages.isEmpty) {
        loadingStatus.value = LoadMoreStatus.completed;
      } else {
        loadingStatus.value = LoadMoreStatus.loaded;
      }
    } catch (err) {
      loadingStatus.value = LoadMoreStatus.completed;
      CustomAlert.error(
        msg: err.toString(),
      );
    }
  }

  void _scrollListener() {
    final maxScrollExtent = scrollController.position.maxScrollExtent / 2;
    if (scrollController.offset > maxScrollExtent &&
        loadingStatus.value != LoadMoreStatus.loading &&
        loadingStatus.value != LoadMoreStatus.completed) {
      loadMoreMessages();
    }
  }

  void cancelRecord() {
    isRecordWidgetEnable.value = false;
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    Get.find<SendMessageController>().emitTypingChange(0);
  }

  void stopRecord(BuildContext context) async {
    isRecordWidgetEnable.value = false;
    await recorder.stop();
    Get.find<SendMessageController>()
        .emitVoice(context, recordPath!, recordTime.value);
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    Get.find<SendMessageController>().emitTypingChange(0);
  }

  void startRecord(BuildContext context) async {
    if (await recorder.hasPermission()) {
      final t = (await getTemporaryDirectory()).path;
      recordPath = "$t/${"${DateTime.now().millisecondsSinceEpoch}.m4a"}";
      isRecordWidgetEnable.value = true;
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      Get.find<SendMessageController>().emitTypingChange(3);
      try {
        await recorder.start(
            encoder: AudioEncoder.AAC_HE,
            bitRate: 18000,
            samplingRate: 64100.0,
            path: recordPath!);
      } catch (err) {
        Helpers.vlog(err.toString());
        CustomAlert.customAlertDialog(
            context: context,
            errorMessage:
                "record not supported on emulator run on real device !");
        cancelRecord();
        rethrow;
      }
    }
  }

  void setAudioPlayerListeners() {
    audioPlayer.onAudioPositionChanged.listen((event) {
      if (currentVoicePlayer != null) {
        currentVoicePlayer!.messageAttachment!.currentPlayPosition.value =
            event;
      }
    });
    audioPlayer.onDurationChanged.listen((event) {
      if (currentVoicePlayer != null) {
        currentVoicePlayer!.messageAttachment!.maxDuration.value = event;
      }
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      if (currentVoicePlayer != null) {
        currentVoicePlayer!.messageAttachment!.currentPlayPosition.value =
            Duration.zero;
        currentVoicePlayer!.messageAttachment!.isVoicePlying.value = false;
        currentVoicePlayer = null;
      }
    });
  }

  void playVoice(VChatMessage msg) async {
    if (currentVoicePlayer != null && msg.id != currentVoicePlayer!.id) {
      //there are voice working
      currentVoicePlayer!.messageAttachment!.isVoicePlying.value = false;
      currentVoicePlayer!.messageAttachment!.currentPlayPosition.value =
          Duration.zero;
    }

    msg.messageAttachment!.isVoicePlying.value = true;
    currentVoicePlayer = msg;
    audioPlayer.play(
      ServerConfig.messagesMediaBaseUrl + msg.messageAttachment!.playUrl!,
      stayAwake: true,
    );
  }

  void pauseVoice(VChatMessage msg) {
    if (audioPlayer.state == PlayerState.PLAYING) {
      msg.messageAttachment!.isVoicePlying.value = false;
      audioPlayer.pause();
    }
  }

  void seekVoiceTo(VChatMessage message, double value) {
    if (currentVoicePlayer != null && message.id != currentVoicePlayer!.id) {
      currentVoicePlayer!.messageAttachment!.isVoicePlying.value = false;
    }
    currentVoicePlayer = message;
    audioPlayer.seek(
      Duration(
        milliseconds: value.toInt(),
      ),
    );
  }

  void _connectMessageSocket() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _socket = _getSocket();
    _socket.onConnect((data) async {
      _socket.on("all_messages", (data) async {
        final msgList = (jsonDecode(data)) as List;
        final x = msgList.map((e) => VChatMessage.fromMap(e)).toList();
        await localStorageService.setRoomMessages(currentRoomId.toString(), x);
        messagesList.assignAll(x);
      });
      _socket.on('new_message', (data) async {
        final msgMap = jsonDecode(data);

        final message = VChatMessage.fromMap(msgMap);
        if (!messagesList.contains(message)) {
          messagesList.insert(0, message);
          await localStorageService.insertMessage(
              currentRoomId.toString(), message);
        }
      });
      _socket.on('see_last_message', (resMap) {
        if (resMap == myModel!.id) {
          isLastMessageSeen.value = true;
        } else {
          isLastMessageSeen.value = false;
        }
      });
      _socket.onReconnecting((data) {
        offAllListeners();
        cache.clear();
      });
      await Future.delayed(const Duration(milliseconds: 100));
      _socket.emit("join", currentRoomId.toString());
    });
  }

  Socket _getSocket() {
    return io("${ServerConfig.serverIp}/message", <String, dynamic>{
      'transports': ['websocket'],
      'pingTimeout': 5000,
      'connectTimeout': 5000,
      'pingInterval': 5000,
      'extraHeaders': <String, String>{
        'Authorization': VChatAppService.to.vChatUser!.accessToken
      },
      'forceNew': true
    });
  }
}
