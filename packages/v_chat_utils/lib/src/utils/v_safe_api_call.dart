import 'package:flutter/cupertino.dart';

import '../../v_chat_utils.dart';

Future<void> vSafeApiCall<T>(
    {Function()? onLoading,
    required Function() request,
    required Function(T response) onSuccess,
    Function(String exception)? onError,
    BuildContext? showSnackError}) async {
  try {
    if (onLoading != null) {
      onLoading();
    }
    final res = await request();
    await onSuccess(res);
    return;
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
    return;
  }
}
