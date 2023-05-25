// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

import '../../core/v_circle_avatar.dart';

class UserIconWidget extends StatelessWidget {
  final String url;
  final String userName;
  final Widget subTitle;
  final bool isVisible;

  const UserIconWidget({
    Key? key,
    required this.url,
    required this.userName,
    required this.subTitle,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          VCircleAvatar(
            fullUrl: url,
            radius: 60,
          ),
          SizedBox(
            height: 20,
          ),
          userName.h5.color(Colors.white),
          SizedBox(
            height: 5,
          ),
          subTitle
        ],
      ),
    );
  }
}
