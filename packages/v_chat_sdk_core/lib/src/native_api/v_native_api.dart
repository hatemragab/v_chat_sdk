import 'package:v_chat_sdk_core/src/http/api_service/channel/channel_api_service.dart';
import 'package:v_chat_sdk_core/src/http/api_service/message/message_api_service.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_socket.dart';

import '../../v_chat_sdk_core.dart';
import '../http/api_service/profile/profile_api_service.dart';
import '../local_db/tables/db_provider.dart';
import 'local/native_local_cache.dart';
import 'local/native_local_message.dart';
import 'local/native_local_room.dart';

class VNativeApi {
  final local = _LocalNativeApi();
  final remote = _RemoteNativeApi(
    ChannelApiService.init(),
    MessageApiService.init(),
    ProfileApiService.init(),
  );

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
    return _instance;
  }
}

class _LocalNativeApi {
  late final NativeLocalMessage message;
  late final NativeLocalRoom room;
  late final NativeLocalApiCache apiCache;

  Future init() async {
    final database = await DBProvider.instance.database;
    message = NativeLocalMessage(database);
    await message.prepareMessages();
    room = NativeLocalRoom(database, message);
    apiCache = NativeLocalApiCache(database);
    // await room.prepareRooms();
  }
}

class _RemoteNativeApi {
  final remoteSocketIo = NativeRemoteSocketIo();
  final ChannelApiService _room;
  final MessageApiService _nativeRemoteMessage;
  final ProfileApiService _nativeProfileApiService;

  _RemoteNativeApi(
    this._room,
    this._nativeRemoteMessage,
    this._nativeProfileApiService,
  );

  ChannelApiService get room => _room;

  final remoteAuth = NativeRemoteAuth(
    AuthApiService.init(),
  );

  MessageApiService get message => _nativeRemoteMessage;

  ProfileApiService get profile => _nativeProfileApiService;
}
