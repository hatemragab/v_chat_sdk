import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:textless/textless.dart';

import 'sheet_vertical_item.dart';

class CustomVerticalSheetItem {
  static Future<int?> normal(BuildContext context,final List<CustomSheetModel> items) async {
    return await showCupertinoModalPopup<int?>(
      barrierDismissible: true,
      semanticsDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: items.map(
              (e) {
                if (!e.isHidden) {
                  return CupertinoActionSheetAction(
                    child: Row(
                      mainAxisAlignment: e.iconData != null
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        e.iconData != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, left: 5),
                                child: Icon(e.iconData!),
                              )
                            : const SizedBox.shrink(),
                        e.text.text,
                      ],
                    ),
                    onPressed: () async {
                      Navigator.pop(context, e.value);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ).toList());
      },
    );
  }
}
