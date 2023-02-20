// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:v_chat_sdk_core/src/http/api_service/call/call_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VCallApiService {
  VCallApiService._();

  static CallApi? _callApi;

  Future<String> createCall({
    required String roomId,
    required Map<String, dynamic> payload,
    required bool withVideo,
  }) async {
    final res = await _callApi!.createCall(roomId, {
      "payload": jsonEncode(payload),
      "withVideo": withVideo,
    });
    throwIfNotSuccess(res);
    return extractDataFromResponse(res)['meetId'] as String;
  }

  Future<bool> acceptCall({
    required String meetId,
    required Map<String, dynamic> answerPayload,
  }) async {
    final res = await _callApi!.acceptCall(meetId, {
      "payload": jsonEncode(answerPayload),
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> cancelCall(String meetId) async {
    final res = await _callApi!.cancelCall(meetId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> endCall(String meetId) async {
    final res = await _callApi!.endCall(meetId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> rejectCall(String meetId) async {
    final res = await _callApi!.rejectCall(meetId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VOnNewCallEvent?> getActiveCall() async {
    final res = await _callApi!.getActiveCall();
    throwIfNotSuccess(res);
    final data =
        (res.body as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
    if (data == null) return null;
    final obj = VNewCallModel.fromMap(data);
    return VOnNewCallEvent(roomId: obj.roomId, data: obj);
  }

  Future<List<VCallHistory>> getCallHistory() async {
    final res = await _callApi!.getCallHistory();
    throwIfNotSuccess(res);
    final data = (res.body as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => VCallHistory.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  static VCallApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _callApi ??= CallApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VCallApiService._();
  }
}
