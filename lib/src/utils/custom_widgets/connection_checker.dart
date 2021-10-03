import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import '../../enums/socket_state_type.dart';
import '../../services/socket_service.dart';

import 'rounded_container.dart';

class ConnectionChecker extends GetView {
  const ConnectionChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SocketService _socket = SocketService.to;
    return Obx(() {
      if (_socket.socketState.value == SocketStateType.connecting) {
        return RoundedContainer(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10),
          padding: const EdgeInsets.all(5),
          child: "connecting...".text.alignCenter.color(Colors.white),
        );
      } else {
        return const SizedBox.shrink();
      }
    });

  }
}
