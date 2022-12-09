import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/platfrom_widgets/platform_cache_image_widget.dart';
import '../controllers/create_broadcast_controller.dart';

class CreateBroadcastView extends GetView<CreateBroadcastController> {
  const CreateBroadcastView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Broadcast'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<CreateBroadcastController>(
                assignId: true,
                builder: (logic) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: controller.groupImage == null
                              ? const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 100,
                                )
                              : PlatformCacheImageWidget(
                                  source: controller.groupImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 2,
                        child: FloatingActionButton(
                          mini: true,
                          onPressed: controller.onCameraClick,
                          child: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(hintText: "broadcast title"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: controller.onSave,
                child: const Text("Create Broadcast"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
