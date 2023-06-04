// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';

import '../../../core/widgets/async_widgets_builder.dart';
import '../../../core/widgets/chat_btn.dart';
import '../../../v_chat/platform_cache_image_widget.dart';
import '../controllers/peer_profile_controller.dart';

class PeerProfileView extends GetView<PeerProfileController> {
  const PeerProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Profile View'),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ChatBtn(
          onPress: controller.onStartChat,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AsyncWidgetsBuilder(
          apiCallStatus: controller.apiCallStatus,
          successWidget: () {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: VPlatformCacheImageWidget(
                          source: controller.peerData.imgAsPlatformSource,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(child: controller.peerData.userName.h6),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
