import 'package:flutter/cupertino.dart';

import '../../v_chat_utils.dart';

Future<void> vSafeApiCall<T>({
  Function()? onLoading,
  required Future<T> Function() request,
  required Function(T response) onSuccess,
  VoidCallback? finallyCallback,
  Function(String exception)? onError,
  BuildContext? showSnackError,
}) async {
  try {
    if (onLoading != null) {
      onLoading();
    }
    final res = await request();
    await onSuccess(res);
  } catch (err) {
    print(err);
    if (showSnackError != null) {
      VAppAlert.showErrorSnackBar(
        msg: err.toString(),
        context: showSnackError,
      );
    }
    if (onError != null) {
      onError(err.toString());
    }
  } finally {
    if (finallyCallback != null) {
      finallyCallback();
    }
  }
}
