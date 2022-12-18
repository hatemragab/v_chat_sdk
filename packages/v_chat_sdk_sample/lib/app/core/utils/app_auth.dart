import 'package:v_chat_sdk_sample/app/core/enums.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class AppAuth {
  static UserModel get getMyModel {
    return UserModel.fromMap(AppPref.getMap(StorageKeys.myProfile)!);
  }
}
