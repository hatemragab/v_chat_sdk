// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:v_chat_sdk_core/src/http/api_service/block/block_api_service.dart';
import 'package:v_chat_sdk_core/src/http/api_service/call/call_api_service.dart';
import 'package:v_chat_sdk_core/src/http/api_service/channel/channel_api_service.dart';
import 'package:v_chat_sdk_core/src/http/api_service/message/message_api_service.dart';
import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api_service.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/db_provider.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_cache.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_message.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_room.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_socket.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VNativeApi {
  final local = VLocalNativeApi();
  final remote = VRemoteNativeApi(
    VChannelApiService.init(),
    VMessageApiService.init(),
    VProfileApiService.init(),
    VCallApiService.init(),
    VBlockApiService.init(),
  );
  final streams = VStreams();

  VNativeApi._();

  bool _isControllerInit = false;

  static final _instance = VNativeApi._();

  static VNativeApi get I {
    return _instance;
  }

  static Future<VNativeApi> init() async {
    assert(
      !_instance._isControllerInit,
      'This controller is already initialized',
    );
    _instance._isControllerInit = true;
    await _instance.local.init();
    await _instance.local.dbCompleter.future;
    return _instance;
  }
}

class VLocalNativeApi {
  late final NativeLocalMessage message;
  late final NativeLocalRoom room;
  late final NativeLocalApiCache apiCache;

  Completer<void> get dbCompleter => DBProvider.instance.dbCompleter;

  Future<VLocalNativeApi> init() async {
    final database = await DBProvider.instance.database;
    message = NativeLocalMessage(database);
    await message.prepareMessages();
    room = NativeLocalRoom(database, message);
    apiCache = NativeLocalApiCache(database);
    return this;
  }

  Future reCreate() async {
    await message.reCreateMessageTable();
    await room.reCreateRoomTable();
  }
}

class VRemoteNativeApi {
  final socketIo = NativeRemoteSocketIo();
  final VChannelApiService _room;
  final VMessageApiService _nativeRemoteMessage;
  final VCallApiService _nativeRemoteCallApiService;
  final VBlockApiService _nativeRemoteBlockApiService;
  final VProfileApiService _nativeProfileApiService;

  VRemoteNativeApi(
    this._room,
    this._nativeRemoteMessage,
    this._nativeProfileApiService,
    this._nativeRemoteCallApiService,
    this._nativeRemoteBlockApiService,
  );

  VChannelApiService get room => _room;

  final remoteAuth = NativeRemoteAuth(
    VAuthApiService.init(),
  );
  Future<http.Response> nativeHttp(
    Uri uri, {
    required VChatHttpMethods method,
    required Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) async {
    headers['authorization'] = "Bearer ${VAppPref.getHashedString(
      key: VStorageKeys.vAccessToken.name,
    )}";
    headers["clint-version"] = VAppConstants.clintVersion;
    switch (method) {
      case VChatHttpMethods.get:
        return http.get(uri, headers: headers);
      case VChatHttpMethods.post:
        return http.post(uri, body: body, headers: headers);
      case VChatHttpMethods.patch:
        return http.patch(uri, body: body, headers: headers);
      case VChatHttpMethods.delete:
        return http.delete(uri, body: body, headers: headers);
      case VChatHttpMethods.put:
        return http.put(uri, body: body, headers: headers);
    }
  }

  VMessageApiService get message => _nativeRemoteMessage;

  VProfileApiService get profile => _nativeProfileApiService;
  VCallApiService get calls => _nativeRemoteCallApiService;
  VBlockApiService get block => _nativeRemoteBlockApiService;
}
