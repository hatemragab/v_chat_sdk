import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/platfrom_widgets/platform_cache_image_widget.dart';
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
                  logic.productImage == null
                      ? InkWell(
                          onTap: logic.onCameraClick,
                          child: const Icon(
                            Icons.image,
                            size: 90,
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          child: PlatformCacheImageWidget(
                            source: controller.productImage!,
                            fit: BoxFit.contain,
                          ),
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
                  ElevatedButton(
                    onPressed: controller.create,
                    child: const Text("Create"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
