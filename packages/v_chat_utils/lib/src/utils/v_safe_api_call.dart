import 'dart:developer';

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
    return;
  } catch (err, stacktrace) {
    if (showSnackError != null) {
      VAppAlert.showErrorSnackBar(
        msg: err.toString(),
        context: showSnackError,
      );
    }
    if (onError != null) {
      onError(err.toString());
    }
    log(err.toString(), error: err, stackTrace: stacktrace);
    return;
  } finally {
    if (finallyCallback != null) {
      finallyCallback();
    }
  }
  return;
}
