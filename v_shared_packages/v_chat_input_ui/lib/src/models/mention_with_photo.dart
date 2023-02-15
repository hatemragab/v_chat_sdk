// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';

class VMentionWithPhoto extends MentionData {
  final String photo;

  VMentionWithPhoto({
    required super.id,
    required super.display,
    required this.photo,
  });
}
