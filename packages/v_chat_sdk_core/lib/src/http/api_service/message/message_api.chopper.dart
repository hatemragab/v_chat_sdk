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
    final Uri $url = Uri.parse('channel/{roomId}/message/');
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
}
