// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/material.dart';

abstract class VAppAlert {
  static Future<int> showAskYesNoDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String cancel,
    required String ok,
  }) async {
    final x = await adaptive_dialog.showOkCancelAlertDialog(
      context: context,
      title: title,
      message: content,
      cancelLabel: cancel,
      okLabel: ok,
    );
    if (x == OkCancelResult.ok) {
      return 1;
    }
    return 0;
  }

  static Future<ModelSheetItem?> showModalSheet<T>({
    String? title,
    required List<ModelSheetItem> content,
    required BuildContext context,
    required String cancel,
  }) async {
    return await adaptive_dialog.showModalActionSheet<ModelSheetItem?>(
      context: context,
      title: title,
      cancelLabel: cancel,
      isDismissible: true,
      actions: content
          .map((e) => SheetAction<ModelSheetItem>(
                label: e.title,
                icon: e.iconData?.icon,
                key: e,
              ))
          .toList(),
    );
  }

  static void showSuccessSnackBar({
    required String msg,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(
        seconds: 3,
      ),
    ));
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
