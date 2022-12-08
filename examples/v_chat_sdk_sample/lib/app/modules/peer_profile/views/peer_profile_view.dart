import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';

import '../../../core/platfrom_widgets/platform_cache_image_widget.dart';
import '../../../core/widgets/async_widgets_builder.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AsyncWidgetsBuilder(
          apiCallStatus: controller.apiCallStatus,
          successWidget: () {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: PlatformCacheImageWidget(
                        source: controller.peerData.imgAsPlatformSource,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  controller.peerData.userName.h6,
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: controller.onStartChat,
                        child: const Text("Start Chat"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
