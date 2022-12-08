import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_alert.dart';

import '../enums.dart';

Future<void> safeApiCall<T>({
  Function()? onLoading,
  bool showSnackError = true,
  required Rx<ApiCallStatus> apiState,
  required Function() request,
  required Function(T response) onSuccess,
  Function(String exception)? onError,
}) async {
  try {
    if (onLoading != null) {
      onLoading();
    }
    apiState.value = ApiCallStatus.loading;
    final res = await request();
    await onSuccess(res);
    apiState.value = ApiCallStatus.success;
    return;
  } catch (err) {
    if (showSnackError) {
      AppAlert.showErrorSnackBar(msg: err.toString());
    }
    apiState.value = ApiCallStatus.error;
    if (onError != null) {
      onError(err.toString());
    }
    return;
  }
}
