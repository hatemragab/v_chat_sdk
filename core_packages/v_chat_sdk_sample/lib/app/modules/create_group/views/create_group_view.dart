// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../v_chat/platform_cache_image_widget.dart';
import '../controllers/create_group_controller.dart';

class CreateGroupView extends GetView<CreateGroupController> {
  const CreateGroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create group'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<CreateGroupController>(
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
                              : VPlatformCacheImageWidget(
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
                decoration: const InputDecoration(hintText: "group title"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: controller.onSave,
                child: const Text("Create Group"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
