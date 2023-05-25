// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../v_chat_media_editor.dart';

class FileItem extends StatelessWidget {
  final VMediaFileRes file;
  final VoidCallback onCloseClicked;
  final Function(VMediaFileRes item) onDelete;

  const FileItem({
    Key? key,
    required this.file,
    required this.onCloseClicked,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  onPressed: onCloseClicked,
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(file),
                      icon: const Icon(
                        PhosphorIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.green),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    PhosphorIcons.file,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    file.data.name.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
