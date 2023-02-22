// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

Future<T?> vSafeApiCall<T>({
  Function()? onLoading,
  required Future<T> Function() request,
  required Function(T response) onSuccess,
  VoidCallback? finallyCallback,
  bool ignoreTimeoutAndNoInternet = true,
  Function(String exception, StackTrace trace)? onError,
}) async {
  try {
    if (onLoading != null) {
      onLoading();
    }
    final res = await request();
    await onSuccess(res);
    return res;
  } on SocketException catch (err, stacktrace) {
    //_showError(err, showToastError);
    if (onError != null) {
      onError(err.toString(), stacktrace);
    }
    if (!ignoreTimeoutAndNoInternet) {
      log("", error: err, stackTrace: stacktrace, level: 1000);
    }
  } on TimeoutException catch (err, stacktrace) {
    // _showError(err, showToastError);
    if (onError != null && !ignoreTimeoutAndNoInternet) {
      onError(err.toString(), stacktrace);
    }
    if (!ignoreTimeoutAndNoInternet) {
      log("", error: err, stackTrace: stacktrace, level: 1000);
    }
  } catch (err, stacktrace) {
    // _showError(err, showToastError);
    if (onError != null) {
      onError(err.toString(), stacktrace);
    }
    log("", error: err, stackTrace: stacktrace, level: 1000);
  } finally {
    if (finallyCallback != null) {
      finallyCallback();
    }
  }
  return null;
}

// void _showError(Object err, bool isAllow) {
//   if (isAllow) {
//     VAppAlert.showOverlaySupport(
//       title: "Connection error",
//       textStyle: const TextStyle(color: Colors.white),
//       background: Colors.red,
//     );
//     // VAppAlert.showErrorSnackBar(
//     //   msg: err.toString(),
//     //   context: context,
//     // );
//   }
// }
