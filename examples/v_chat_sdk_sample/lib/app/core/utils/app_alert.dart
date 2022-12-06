import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

abstract class AppAlert {
  static ProgressDialog? _progressDialog;

  static Future showLoading(
      {String message = "Please wait ...", bool isDismissible = false}) async {
    _progressDialog = ProgressDialog(
      Get.context!,
      type: ProgressDialogType.Normal,
      isDismissible: isDismissible,
    );
    _progressDialog!.style(
      message: message,
      backgroundColor: Get.isDarkMode ? Colors.black87 : Colors.white,
      borderRadius: 10.0,
      progressWidget: Container(
        padding: const EdgeInsets.all(8.0),
        child: const CircularProgressIndicator(),
      ),
      messageTextStyle: Get.isDarkMode
          ? const TextStyle(color: Colors.white)
          : const TextStyle(color: Colors.black),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    await _progressDialog!.show();
  }

  static updateProgress(String message) {
    _progressDialog!.update(message: message);
  }

  static Future hideLoading() async {
    if (_progressDialog == null) {
      log("hideLoading _progressDialog is nulllll");
      return;
    }
    await _progressDialog!.hide();
  }

  static Future<AlertButton> showOkAlertDialog({
    required String title,
    required String content,
  }) async {
    return FlutterPlatformAlert.showAlert(
      windowTitle: title,
      text: content,
    );
  }

  static Future<int> showAskAlertDialog({
    required String title,
    required String content,
  }) async {
    final x = await FlutterPlatformAlert.showAlert(
        windowTitle: title,
        text: content,
        alertStyle: AlertButtonStyle.yesNoCancel);
    if (x == AlertButton.yesButton) {
      return 1;
    }

    return 0;
  }

  static void showSuccessSnackBar({
    required String msg,
  }) {
    Get.showSnackbar(GetSnackBar(
      title: "Success",
      message: msg,
      duration: const Duration(seconds: 3),
    ));
  }

  static void showErrorSnackBar({
    required String msg,
  }) {
    Get.showSnackbar(GetSnackBar(
      title: "Error",
      message: msg,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
    ));
  }
}
