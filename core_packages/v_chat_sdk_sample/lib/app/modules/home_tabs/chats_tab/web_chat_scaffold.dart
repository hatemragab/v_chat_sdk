// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

final vWebChatNavigation = VWebChatNavigation();

class VWebChatNavigation {
  final key = GlobalKey<NavigatorState>();

  Route createAnimatedRoute(
    Widget page, {
    TransitionType transitionType = TransitionType.noAnimation,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case TransitionType.slide:
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

          case TransitionType.noAnimation:
            return child;
        }
      },
    );
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ChatRoute.route:
        return vWebChatNavigation.createAnimatedRoute(ChatRoute(
          room: settings.arguments as VRoom,
        ));
      case IdleRoute.route:
        return vWebChatNavigation.createAnimatedRoute(IdleRoute());
      default:
    }
    return null;
  }
}

class IdleRoute extends StatelessWidget {
  static const route = '/idle';

  const IdleRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'IDLE',
        ),
      ),
    );
  }
}

enum TransitionType { slide, noAnimation }

class ChatRoute extends StatelessWidget {
  const ChatRoute({
    Key? key,
    required this.room,
  }) : super(key: key);
  static const route = '/chat';
  final VRoom room;

  @override
  Widget build(BuildContext context) {
    return VMessagePage(
      vRoom: room,
      context: vWebChatNavigation.key.currentContext!,
    );
  }
}
