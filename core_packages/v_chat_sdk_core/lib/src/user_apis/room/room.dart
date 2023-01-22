import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/api_service/channel/channel_api_service.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class RoomApi {
  final VNativeApi _vNativeApi;
  // final ControllerHelper _helper = ControllerHelper.instance;
  final VChatConfig _chatConfig;
  final _log = Logger('user_api.Room');

  ChannelApiService get _channelApiService => _vNativeApi.remote.room;

  RoomApi(
    this._vNativeApi,
    this._chatConfig,
  );

  Future<VRoom> getPeerRoom({
    required String peerIdentifier,
  }) async {
    return _channelApiService.getPeerRoom(peerIdentifier);
  }

  Future openChatWith(BuildContext buildContext, String identifier) async {
    final localRoom = await _vNativeApi.local.room.getRoomByPeerId(identifier);
    if (localRoom != null) {
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(buildContext, localRoom);
    } else {
      final apiRoom = await _vNativeApi.remote.room.getPeerRoom(identifier);
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(buildContext, apiRoom);
    }
  }
}
