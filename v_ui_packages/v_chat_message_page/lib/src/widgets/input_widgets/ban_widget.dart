// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class BanWidget extends StatelessWidget {
  final bool isMy;
  final VoidCallback onUnBan;

  const BanWidget({super.key, required this.isMy, required this.onUnBan});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VTrans.of(context)
                .labels
                .youDontHaveAccess
                .text
                .color(Colors.white)
                .black,
            // if (isMy)
            //   InkWell(
            //     onTap: onUnBan,
            //     child: "Un block".text.color(Colors.blueAccent),
            //   )
            // else
            //   const SizedBox(),
          ],
        ),
      ),
    );
  }
}
