import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:v_chat_sdk/src/utils/v_chat_extentions.dart';
import '../../services/v_chat_app_service.dart';

class CustomAlert {
  CustomAlert._();

  static void done({String? msg}) {
    Fluttertoast.showToast(
        msg: msg ?? VChatAppService.instance.getTrans().success(),
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
      {String? title,
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
                content: Theme(
                  data: context.isDark
                      ? VChatAppService.instance.darkTheme
                      : VChatAppService.instance.lightTheme,
                  child: Column(
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
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: VChatAppService.instance.navKey!.currentContext!,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }

  static void customLoadingDialog(
      {BuildContext? context, bool dismissible = false}) {
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
                        .getTrans()
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
      context: VChatAppService.instance.navKey!.currentContext!,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }

  static Future<int?> customAskDialog({
    String? title,
    required BuildContext context,
    required String message,
    bool dismissible = true,
  }) async {
    return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Theme(
          data: context.isDark
              ? VChatAppService.instance.darkTheme
              : VChatAppService.instance.lightTheme,
          child: WillPopScope(
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
                            child: VChatAppService.instance
                                .getTrans()
                                .cancel()
                                .text
                                .size(15),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, 1),
                            child: VChatAppService.instance
                                .getTrans()
                                .oK()
                                .text
                                .size(15),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: VChatAppService.instance.navKey!.currentContext!,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }
}
