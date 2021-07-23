import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import 'package:flutter/cupertino.dart';

class CustomAlert {
  static void done({String? msg}) {
    BotToast.showSimpleNotification(
      title: "success",
      duration: Duration(seconds: 3),
      subTitle: msg != null ? msg : "this operation done successfully",
    );
  }

  static void error({String? msg}) {
    BotToast.showSimpleNotification(
      title: "Failed",
      subTitleStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
      subTitle: msg != null ? msg : "this operation failed",
    );
  }

  static void customAlertDialog(
      {required BuildContext context,
      String? title,
      Function()? onPress,
      required String errorMessage,
      bool dismissible = true}) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            return dismissible;
          },
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                title: title == null ? null : title.text.alignCenter,
                contentPadding: EdgeInsets.zero.copyWith(
                    top: title == null ? 20 : 8,
                    bottom: 5,
                    left: 10,
                    right: 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    errorMessage.text.alignCenter,
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                          onPressed: onPress == null
                              ? () => Navigator.pop(context)
                              : onPress,
                          child: "OK".text),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }

  static void customLoadingDialog(
      {required BuildContext context, bool dismissible = false}) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            return dismissible;
          },
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 5, left: 10, right: 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    "Loading please wait".text.bold,
                    const SizedBox(
                      height: 33,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.red,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }

  static void customVerticalSheet({List<Widget>? items}) {
    showModalBottomSheet(
      context: Get.context!,
      enableDrag: true,
      isScrollControlled: true,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.drag_handle)),
              SizedBox(
                height: 10,
              ),
              ...items!,
            ],
          ),
        );
      },
    );
  }

  static Future<int?> customAskDialog(
      {String? title,
      required BuildContext context,
      required String message,
      bool dismissible = true}) async {
    return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            return dismissible;
          },
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                title: title == null ? null : title.text.alignCenter,
                contentPadding: EdgeInsets.zero.copyWith(
                    top: title == null ? 20 : 8,
                    bottom: 5,
                    left: 10,
                    right: 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    message.text.alignCenter,
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, -1),
                          child: "Cancel".text.size(15),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, 1),
                          child: "OK".text.size(15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }
}

class CustomAskButtonSheetModel {
  final String title;
  final int id;
  final IconData? icon;

  CustomAskButtonSheetModel({required this.title, required this.id, this.icon});
}
