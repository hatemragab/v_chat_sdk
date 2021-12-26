import '../dto/v_chat_login_dto.dart';
import '../dto/v_chat_register_dto.dart';
import '../models/v_chat_user.dart';
import '../utils/api_utils/dio/custom_dio.dart';

class AuthProvider {
  Future<VChatUser> login(VChatLoginDto dto) async {
    final data = (await CustomDio()
            .send(reqMethod: "POST", path: "user/login", body: dto.toMap()))
        .data['data'] as Map<String, dynamic>;
    return VChatUser.fromMap(data);
  }

  Future<VChatUser> register(VChatRegisterDto dto) async {
    late Map<String, dynamic> userMap;
    if (dto.userImage != null) {
      userMap = (await CustomDio().uploadFile(
        filePath: dto.userImage!.path,
        apiEndPoint: "user/register",
        body: [
          {"name": dto.name},
          {"email": dto.email},
          {"password": dto.password},
          {"fcmToken": dto.fcmToken.toString()}
        ],
      ))
          .data['data'] as Map<String, dynamic>;
    } else {
      userMap = (await CustomDio().send(
        reqMethod: "POST",
        path: "user/register",
        body: dto.toMap(),
      ))
          .data['data'] as Map<String, dynamic>;
    }

    return VChatUser.fromMap(userMap);
  }
}
