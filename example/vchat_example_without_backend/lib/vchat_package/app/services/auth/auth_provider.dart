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

  Future<VChatUser> register(VchatRegisterDto dto) async {
    String imageThumb = "default_user_image.png";

    if (dto.userImage != null) {
      final imagesData = await upload(dto.userImage!.path);
      imageThumb = imagesData.data['thumbUrl'];
    }
    print("thumbUrl is =>>>>>>>>>>>" + imageThumb);
    final data = (await CustomDio().send(
            reqMethod: "POST",
            path: "user/register",
            body: dto.toMap(imageThumb)))
        .data['data'];

    return VChatUser.fromMap(data);
  }

  Future<ServerDefaultResponse> upload(String filePath) async {
    final res = await CustomDio().upload(
        apiEndPoint: "user/file/upload", filePath: filePath, loading: true);
    return ServerDefaultResponse.fromMap(res.data);
  }
}
