import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/service/message_local_storage_service.dart';
import 'package:v_chat_sdk_core/src/local_db/service/room_local_storage_service.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/db_provider.dart';

import '../../v_chat_sdk_core.dart';
import '../models/api_cache_model.dart';
import 'core/abstraction/base_local_api_cache_repo.dart';
import 'core/imp/api_cache/api_cache_memory_imp.dart';
import 'core/imp/api_cache/api_cache_sql_imp.dart';

class LocalStorageService
    with MessageLocalStorage, RoomLocalStorageService, CacheLocalStorage {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();
  Future<LocalStorageService> init() async {
    final database = await DBProvider.instance.database;
    initMessageLocalStorage(
      database: database,
    );
    initRoomLocalStorage(
      database: database,
    );
    initCacheLocalStorage(
      database: database,
    );
    await _prepareDb();
    return this;
  }

  Future _prepareDb() async {
    await offAllRooms();
    await updateMessagesFromSendingToError();
  }

  Future<int> deleteRoomById(DeleteRoomEvent event) async {
    await localMessageRepo.deleteAllMessagesByRoomId(event.roomId);
    emitter.fire(event);
    return localRoomRepo.delete(event);
  }

  Future<void> safeInsertRoom(VRoom room) async {
    if (await localRoomRepo.getOneWithLastMessageByRoomId(room.id) == null) {
      final event = InsertRoomEvent(roomId: room.id, room: room);
      await localRoomRepo.insert(event);
      await safeInsertMessage(room.lastMessage);
      emitter.fire(event);
    }
  }

  Future<int> insertMessage(
    VBaseMessage message,
  ) async {
    if (message is VEmptyMessage) {
      return 0;
    }
    final event = VInsertMessageEvent(
      messageModel: message,
      localId: message.localId,
      roomId: message.roomId,
    );
    await localMessageRepo.insert(
      event,
    );
    if (!message.isMeSender) {
      ///increment the chat counter
      await updateRoomUnreadCountAddOne(
        UpdateRoomUnReadCountByOneEvent(roomId: message.roomId),
      );
    }
    emitter.fire(event);
    return 1;
  }

  Future<int> safeInsertMessage(VBaseMessage message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (await getMessageByLocalId(message.localId) == null) {
      return insertMessage(message);
    }
    return 0;
  }

  Future<int> cacheRooms(List<VRoom> rooms) async {
    if (rooms.isEmpty) {
      await localRoomRepo.reCreate();
      return 1;
    }
    await localMessageRepo.insertMany(rooms.map((e) => e.lastMessage).toList());
    return localRoomRepo.insertMany(
      rooms,
    );
  }

  Future logout() async {
    await reCreateRoomTable();
    await reCreateMessageTable();
    await _apiCacheRepo.reCreate();
  }
}

mixin CacheLocalStorage {
  late BaseLocalApiCacheRepo _apiCacheRepo;

  initCacheLocalStorage({
    required Database database,
  }) {
    if (Platforms.isWeb) {
      _apiCacheRepo = ApiCacheMemoryImp();
    } else {
      _apiCacheRepo = ApiCacheSqlImp(database);
    }
  }

  Future<int> insertToApiCache(ApiCacheModel model) async {
    return _apiCacheRepo.insert(model);
  }

  Future<ApiCacheModel?> getOneApiCache(String endPoint) async {
    return _apiCacheRepo.getOneByEndPoint(endPoint);
  }
}
