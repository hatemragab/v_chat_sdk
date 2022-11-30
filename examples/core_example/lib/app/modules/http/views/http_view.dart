import 'package:core_example/app/modules/http/views/widgets/http_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/http_controller.dart';

class HttpView extends GetView<HttpController> {
  const HttpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http View'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return GetBuilder<HttpController>(
            id: controller.httpModels[index].endpoint,
            builder: (logic) {
              return HttpItem(
                httpModel: controller.httpModels[index],
                controller: logic,
              );
            },
          );
        },
        itemCount: controller.httpModels.length,
      ),
    );
  }
}
