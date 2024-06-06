// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CallApi extends CallApi {
  _$CallApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CallApi;

  @override
  Future<Response<dynamic>> getActiveCall() {
    final Uri $url = Uri.parse('call/active');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCallHistory() {
    final Uri $url = Uri.parse('call/history');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createCall(
    String roomId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('call/create/${roomId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> acceptCall(
    String meetId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('call/accept/${meetId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> cancelCall(String meetId) {
    final Uri $url = Uri.parse('call/cancel/${meetId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> rejectCall(String meetId) {
    final Uri $url = Uri.parse('call/reject/${meetId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> endCall(String meetId) {
    final Uri $url = Uri.parse('call/end/${meetId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
