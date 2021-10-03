import '../../dto/vchat_login_dto.dart';
import '../../dto/vchat_register_dto.dart';
import '../../models/vchat_user.dart';
import '../../utils/api_utils/dio/custom_dio.dart';
import '../../utils/api_utils/dio/server_default_res.dart';

class AuthProvider {
  Future<VChatUser> login(VChatLoginDto dto) async {
    final data = (await CustomDio()
            .send(reqMethod: "POST", path: "user/login", body: dto.toMap()))
        .data['data'];
    return VChatUser.fromMap(data);
  }

  Future<VChatUser> register(VChatRegisterDto dto) async {
    dynamic userMap;

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
          .data['data'];
    } else {
      userMap = (await CustomDio().send(
        reqMethod: "POST",
        path: "user/register",
        body: dto.toMap(),
      ))
          .data['data'];
    }

    return VChatUser.fromMap(userMap);
  }

  Future<ServerDefaultResponse> upload(String filePath) async {
    final res = await CustomDio().upload(
        apiEndPoint: "user/file/upload", filePath: filePath, loading: true);
    return ServerDefaultResponse.fromMap(res.data);
  }
}
