// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../core/agora_user.dart';

class AgoraVideoView extends StatelessWidget {
  const AgoraVideoView({
    super.key,
    required double viewAspectRatio,
    required AgoraUser user,
  })  : _viewAspectRatio = viewAspectRatio,
        _user = user;

  final double _viewAspectRatio;
  final AgoraUser _user;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AspectRatio(
          aspectRatio: _viewAspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: _user.isAudioEnabled ?? false ? Colors.blue : Colors.red,
                width: 2.0,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    maxRadius: 18,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade600,
                      size: 24.0,
                    ),
                  ),
                ),
                if (_user.isVideoEnabled ?? false)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8 - 2),
                    child: _user.view,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
