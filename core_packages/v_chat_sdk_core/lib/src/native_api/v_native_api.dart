import 'package:http/http.dart' as http;
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
  final local = _LocalNativeApi();
  final remote = _RemoteNativeApi(
    ChannelApiService.init(),
    MessageApiService.init(),
    ProfileApiService.init(),
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

  Future reCreate() async {
    await message.reCreateMessageTable();
    await room.reCreateRoomTable();
  }
}

class _RemoteNativeApi {
  final socketIo = NativeRemoteSocketIo();
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
        return http.get(uri,headers: headers);
      case VChatHttpMethods.post:
        return http.post(uri, body: body,headers: headers);
      case VChatHttpMethods.patch:
        return http.patch(uri, body: body,headers: headers);
      case VChatHttpMethods.delete:
        return http.delete(uri, body: body,headers: headers);
      case VChatHttpMethods.put:
        return http.put(uri, body: body,headers: headers);
    }
  }

  MessageApiService get message => _nativeRemoteMessage;

  ProfileApiService get profile => _nativeProfileApiService;
}
