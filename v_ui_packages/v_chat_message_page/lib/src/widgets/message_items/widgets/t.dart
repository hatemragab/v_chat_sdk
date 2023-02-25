// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CustomCard extends StatelessWidget {
  final String msg;
  final Widget timeTextWidget;

  const CustomCard({
    super.key,
    required this.msg,
    required this.timeTextWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AutoDirection(
      text: msg,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  //real message
                  TextSpan(
                    text: "$msg      ",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  //fake additionalInfo as placeholder
                  const TextSpan(
                    text: "12:10 AM",
                    style: TextStyle(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //real additionalInfo
          PositionedDirectional(
            end: 0,
            bottom: 2,
            child: timeTextWidget,
          )
        ],
      ),
    );
  }
}
