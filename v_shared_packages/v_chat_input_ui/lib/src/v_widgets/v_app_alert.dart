// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/material.dart';

abstract class VAppAlert {
  static void showErrorSnackBar({
    required String msg,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(
        seconds: 5,
      ),
    ));
  }

  static Future<ModelSheetItem?> showModalSheet<T>({
    String? title,
    required List<ModelSheetItem> content,
    required BuildContext context,
    required String cancelText,
  }) async {
    return await adaptive_dialog.showModalActionSheet<ModelSheetItem?>(
      context: context,
      title: title,
      cancelLabel: cancelText,
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
