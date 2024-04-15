// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$MessageApi extends MessageApi {
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
  Future<Response<dynamic>> getStarMessages(String roomId) {
    final Uri $url = Uri.parse('channel/${roomId}/message/stars');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> unStarMessage(
    String roomId,
    String messageId,
  ) {
    final Uri $url =
        Uri.parse('channel/${roomId}/message/${messageId}/un-star');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> starMessage(
    String roomId,
    String messageId,
  ) {
    final Uri $url = Uri.parse('channel/${roomId}/message/${messageId}/star');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addOneSeen(
    String roomId,
    String messageId,
  ) {
    final Uri $url =
        Uri.parse('channel/${roomId}/message/${messageId}/one-seen');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
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
}
