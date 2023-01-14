import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../v_chat_utils.dart';

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
                icon: e.iconData == null ? null : e.iconData!.icon,
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
      SnackBar(
        content: Text(msg),
        duration: const Duration(
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
        content: Text(msg),
        duration: const Duration(
          seconds: 5,
        ),
      ),
    );
  }

  static void showOverlaySupport({
    Duration duration = const Duration(seconds: 5),
    String? subtitle,
    required String title,
    Widget? trailing,
    TextStyle? textStyle,
    Widget? leading,
    Color? background,
  }) {
    showSimpleNotification(
      Text(title, style: textStyle),
      background: background,
      autoDismiss: true,
      trailing: trailing,
      leading: leading,
      slideDismissDirection: DismissDirection.horizontal,
      subtitle: subtitle == null ? null : Text(subtitle),
      duration: duration,
    );
  }

  static void showOverlayWithBarrier({
    required String title,
    required String subtitle,
    Duration duration = const Duration(seconds: 5),
  }) {
    showOverlay(
      (context, t) {
        return Container(
          color: Color.lerp(Colors.transparent, Colors.black54, t),
          child: FractionalTranslation(
            translation:
                Offset.lerp(const Offset(0, -1), const Offset(0, 0), t)!,
            child: Column(
              children: <Widget>[
                _MessageNotification(
                  title: title,
                  subtitle: subtitle,
                  onReply: () {
                    OverlaySupportEntry.of(context)!.dismiss();
                  },
                  key: ModalKey(const Object()),
                ),
              ],
            ),
          ),
        );
      },
      duration: duration,
    );
  }
}

class ModelSheetItem<T> {
  final T id;
  final String title;
  final Icon? iconData;

  ModelSheetItem({
    required this.title,
    required this.id,
    this.iconData,
  });
}

class _MessageNotification extends StatelessWidget {
  final VoidCallback onReply;

  final String? subtitle;
  final String title;

  const _MessageNotification({
    Key? key,
    required this.onReply,
    required this.subtitle,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle!),
          trailing: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              onReply();
            },
          ),
        ),
      ),
    );
  }
}
