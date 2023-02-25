// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$MessageApi extends MessageApi {
  _$MessageApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = MessageApi;

  @override
  Future<Response<dynamic>> createMessage(
    String roomId,
    List<PartValue<dynamic>> body,
    MultipartFile? file,
    MultipartFile? secondFile,
  ) {
    final Uri $url = Uri.parse('channel/${roomId}/message/');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile?>(
        'file',
        file,
      ),
      PartValueFile<MultipartFile?>(
        'file',
        secondFile,
      ),
    ];
    $parts.addAll(body);
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getRoomMessages(
    String roomId,
    Map<String, dynamic> query,
  ) {
    final Uri $url = Uri.parse('channel/${roomId}/message/');
    final Map<String, dynamic> $params = query;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteMessageFromMe(
    String roomId,
    String messageId,
  ) {
    final Uri $url =
        Uri.parse('channel/${roomId}/message/${messageId}/delete/me');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteMessageFromAll(
    String roomId,
    String mId,
  ) {
    final Uri $url = Uri.parse('channel/${roomId}/message/${mId}/delete/all');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMessageStatusSummary(
    String roomId,
    String messageId,
  ) {
    final Uri $url =
        Uri.parse('channel/${roomId}/message/${messageId}/status/summary');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMessageStatus(
    String roomId,
    String mId,
    Map<String, Object> query,
    String type,
  ) {
    final Uri $url =
        Uri.parse('channel/${roomId}/message/${mId}/status/${type}');
    final Map<String, dynamic> $params = query;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
