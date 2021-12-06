import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/v_chat_app_service.dart';

class CustomAlert {
  CustomAlert._();

  static void done({required BuildContext context, String? msg}) {
    Fluttertoast.showToast(
        msg: msg ?? VChatAppService.instance.getTrans(context).success(),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    // BotToast.showSimpleNotification(
    //     title: VChatAppService.to.getTrans().success(),
    //     duration: const Duration(seconds: 3),
    //     subTitle: msg ??
    //         VChatAppService.to.getTrans().thisOperationDoneSuccessfully());
  }

  static void error({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // BotToast.showSimpleNotification(
    //   title: VChatAppService.to.getTrans().failed(),
    //   subTitleStyle: const TextStyle(color: Colors.white),
    //   backgroundColor: Colors.red,
    //   duration: const Duration(seconds: 5),
    //   subTitle: msg ?? VChatAppService.to.getTrans().thisOperationFailed(),
    // );
  }

  static void customAlertDialog(
      {Function()? onPress,
      required String errorMessage,
      required BuildContext context,
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
                contentPadding: EdgeInsets.zero
                    .copyWith(top: 20, bottom: 5, left: 10, right: 10),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    errorMessage.text.alignCenter,
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                          onPressed: onPress ?? () => Navigator.pop(context),
                          child: VChatAppService.instance
                              .getTrans(context)
                              .oK()
                              .text),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
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
                    VChatAppService.instance
                        .getTrans(context)
                        .loadingPleaseWait()
                        .text
                        .bold,
                    const SizedBox(
                      height: 33,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: LinearProgressIndicator(
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
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }

  static Future<int?> customAskDialog({
    required String title,
    required BuildContext context,
    bool dismissible = true,
  }) async {
    return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            return dismissible;
          },
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: title.text,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, -1),
                      child: VChatAppService.instance
                          .getTrans(context)
                          .cancel()
                          .text,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 1),
                      child:
                          VChatAppService.instance.getTrans(context).oK().text,
                    ),
                  ],
                )
              : Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: AlertDialog(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      title: title.text,
                      contentPadding: EdgeInsets.zero
                          .copyWith(top: 8, bottom: 5, left: 10, right: 10),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, -1),
                          child: VChatAppService.instance
                              .getTrans(context)
                              .cancel()
                              .text,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 1),
                          child: VChatAppService.instance
                              .getTrans(context)
                              .oK()
                              .text,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }
}
