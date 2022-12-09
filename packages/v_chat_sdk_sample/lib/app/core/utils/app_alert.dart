import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:textless/textless.dart';

abstract class AppAlert {
  static ProgressDialog? _progressDialog;

  static Future showLoading({
    String message = "Please wait ...",
    bool isDismissible = false,
  }) async {
    _progressDialog = ProgressDialog(
      Get.context!,
      type: ProgressDialogType.Normal,
      isDismissible: isDismissible,
    );
    _progressDialog!.style(
      message: message,
      backgroundColor: Get.isDarkMode
          ? const Color(0xff39393d).withOpacity(.9)
          : Colors.white,
      borderRadius: 10.0,
      maxProgress: 100,
      progressWidget: Container(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Row(
            children: const [
              CircularProgressIndicator.adaptive(),
            ],
          ),
        ),
      ),
      messageTextStyle: Get.isDarkMode
          ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          : const TextStyle(color: Colors.black12, fontWeight: FontWeight.bold),
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

  static Future<int> showAskYesNoDialog({
    required String title,
    required String content,
  }) async {
    final x = await FlutterPlatformAlert.showAlert(
      windowTitle: title,
      text: content,
      alertStyle: AlertButtonStyle.yesNo,
    );
    if (x == AlertButton.yesButton) {
      return 1;
    }

    return 0;
  }

  static Future<T?> showAskListDialog<T>({
    required String title,
    required List<T> content,
  }) async {
    return showDialog<T?>(
      context: Get.context!,
      builder: (ctx) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: content
                  .map((e) => ListTile(
                        title: e.toString().text,
                        onTap: () {
                          Navigator.pop(Get.context!, e);
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(Get.context!);
              },
              //todo fix trans
              child: "Cancel".text,
            ),
          ],
        );
      },
    );
  }

  static void showSuccessSnackBar({
    required String msg,
  }) {
    Get.showSnackbar(GetSnackBar(
      //todo fix trans
      title: "Success",
      message: msg,
      duration: const Duration(seconds: 3),
    ));
  }

  static void showErrorSnackBar({
    required String msg,
  }) {
    Get.showSnackbar(GetSnackBar(
      //todo fix trans
      title: "Error",
      message: msg,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
    ));
  }
}
