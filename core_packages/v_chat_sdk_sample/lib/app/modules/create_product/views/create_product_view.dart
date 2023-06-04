// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/widgets/app_btn.dart';

import '../../../v_chat/platform_cache_image_widget.dart';
import '../controllers/create_product_controller.dart';

class CreateProductView extends GetView<CreateProductController> {
  const CreateProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        centerTitle: true,
      ),
      body: GetBuilder<CreateProductController>(
        assignId: true,
        builder: (logic) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: controller.productImage == null
                              ? const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 100,
                                )
                              : VPlatformCacheImageWidget(
                                  source: controller.productImage!,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      hintText: "Product name",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.descController,
                    decoration: const InputDecoration(
                      hintText: "Product description",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Product price",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppBtn(onPress: controller.create, title: "Create")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
