// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_utils/v_chat_utils.dart';

class VSocketStatusEvent extends VAppEvent {
  final bool isConnected;

  const VSocketStatusEvent({required this.isConnected});

  @override
  List<Object?> get props => [isConnected];
}
