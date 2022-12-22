import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_utils/src/utils/extension.dart';

abstract class VAppAlert {
  static ProgressDialog? _progressDialog;

  static Future showLoading(
      {String message = "Please wait ...",
      bool isDismissible = false,
      required BuildContext context}) async {
    _progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: isDismissible,
    );
    _progressDialog!.style(
      message: message,
      backgroundColor: context.isDark
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
      messageTextStyle: context.isDark
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

  static Future<void> showOkAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    String okLabel = "Ok",
  }) async {
    await adaptive_dialog.showOkAlertDialog(
      context: context,
      title: title,
      message: content,
      okLabel: okLabel,
    );
    return;
  }

  static Future<int> showAskYesNoDialog({
    required BuildContext context,
    required String title,
    required String content,
    String okLabel = "Ok",
    String cancelLabel = "Cancel",
  }) async {
    final x = await adaptive_dialog.showOkCancelAlertDialog(
      context: context,
      title: title,
      message: content,
      cancelLabel: cancelLabel,
      okLabel: okLabel,
    );
    if (x == OkCancelResult.ok) {
      return 1;
    }
    return 0;
  }

  static Future<T?> showAskListDialog<T>({
    required String title,
    required List<T> content,
    required BuildContext context,
  }) async {
    return showDialog<T?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: content
                  .map((e) => ListTile(
                        title: e.toString().text,
                        onTap: () {
                          Navigator.pop(context, e);
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              //todo fix trans
              child: "Cancel".text,
            ),
          ],
        );
      },
    );
  }

  static Future<ModelSheetItem?> showModalSheet<T>({
    String? title,
    required List<ModelSheetItem> content,
    required BuildContext context,
  }) async {
    return await adaptive_dialog.showModalActionSheet<ModelSheetItem?>(
      context: context,
      title: title,
      cancelLabel: "Cancel",
      isDismissible: true,
      actions: content
          .map((e) => SheetAction<ModelSheetItem>(
                label: e.title,
                icon: e.iconData,
                key: e,
              ))
          .toList(),
    );
  }

  static void showSuccessSnackBar({
    required String msg,
    required BuildContext context,
  }) {
    context.showSnackBar(
      const SnackBar(
        //todo fix trans
        content: Text("Success"),
        duration: Duration(
          seconds: 3,
        ),
      ),
    );
  }

  static void showErrorSnackBar({
    required String msg,
    required BuildContext context,
  }) {
    context.showSnackBar(
      SnackBar(
        //todo fix trans
        content: Text(msg),
        duration: const Duration(
          seconds: 5,
        ),
      ),
    );
  }
}

class ModelSheetItem<T> {
  final T id;
  final String title;
  final IconData? iconData;

  ModelSheetItem({required this.title, required this.id, this.iconData});
}
