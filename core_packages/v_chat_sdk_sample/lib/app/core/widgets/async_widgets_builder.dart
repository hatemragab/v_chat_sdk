// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums.dart';

// switch between different widgets with animation
// depending on api call status
class AsyncWidgetsBuilder extends StatelessWidget {
  final Rx<ApiCallStatus> apiCallStatus;
  final Widget Function()? loadingWidget;
  final Widget Function() successWidget;
  final Widget Function()? errorWidget;
  final Widget Function()? emptyWidget;
  final Widget Function()? holdingWidget;

  const AsyncWidgetsBuilder({
    Key? key,
    required this.apiCallStatus,
    this.loadingWidget,
    this.errorWidget,
    required this.successWidget,
    this.holdingWidget,
    this.emptyWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getChild();
  }

  _getChild() {
    return Obx(() {
      final apiCallStatusValue = apiCallStatus.value;
      if (apiCallStatusValue == ApiCallStatus.success) {
        return successWidget();
      } else if (apiCallStatusValue == ApiCallStatus.error) {
        if (errorWidget == null) {
          return const Center(
              child: Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
        } else {
          return errorWidget!();
        }
      } else if (apiCallStatusValue == ApiCallStatus.holding) {
        if (holdingWidget == null) {
          return const SizedBox();
        } else {
          return holdingWidget!();
        }
      } else if (apiCallStatusValue == ApiCallStatus.loading) {
        if (loadingWidget == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          return loadingWidget!();
        }
      } else if (apiCallStatusValue == ApiCallStatus.empty) {
        if (emptyWidget == null) {
          return const SizedBox();
        } else {
          return emptyWidget!();
        }
      } else {
        return successWidget();
      }
    });
  }
}
