// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../v_chat_utils.dart';

// switch between different widgets with animation
// depending on api call status
class VAsyncWidgetsBuilder extends StatelessWidget {
  final VChatLoadingState loadingState;
  final Widget Function()? loadingWidget;
  final Widget Function() successWidget;
  final Widget Function()? errorWidget;
  final Widget Function()? emptyWidget;
  final VoidCallback? onRefresh;

  const VAsyncWidgetsBuilder({
    Key? key,
    required this.loadingState,
    this.loadingWidget,
    this.errorWidget,
    this.onRefresh,
    required this.successWidget,
    this.emptyWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loadingState == VChatLoadingState.success) {
      return successWidget();
    } else if (loadingState == VChatLoadingState.error) {
      if (errorWidget == null) {
        return InkWell(
          onTap: onRefresh,
          child: const Center(
            child: Icon(
              Icons.refresh,
              size: 50,
              color: Colors.red,
            ),
          ),
        );
      } else {
        return errorWidget!();
      }
    } else if (loadingState == VChatLoadingState.loading) {
      if (loadingWidget == null) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else {
        return loadingWidget!();
      }
    } else if (loadingState == VChatLoadingState.empty) {
      if (emptyWidget == null) {
        return const SizedBox();
      } else {
        return emptyWidget!();
      }
    } else {
      return successWidget();
    }
  }
}
