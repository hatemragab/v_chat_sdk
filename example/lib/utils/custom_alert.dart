import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class CustomAlert {
  static void showError({required BuildContext context, required String err}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: "Error".text,
          content: err.text,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: "Ok".text)
          ],
        );
      },
    );
  }
  static Future<int?> customChooseDialog(
      {required BuildContext context,
        String? title,
        required List<String> data}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                title != null ? title.text.black.size(19) : SizedBox(),
                ...data.map((e) => InkWell(
                  onTap: () {
                    Navigator.pop(context, data.indexOf(e) );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: e.text,
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
