import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onGallery,
        child: const Text(
          "Open Gallery",
          textAlign: TextAlign.center,
        ),
      ),
      appBar: AppBar(
        title: const Text('Home View'),
        centerTitle: true,
      ),
      body: Obx(() {
        final data = controller.proccessedData;
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.black, height: 20, thickness: 2),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text(
                  data[index].toString(),
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(
                  height: 5,
                ),
                if (data[index] is VMediaImageRes)
                  VPlatformCacheImageWidget(
                    source: (data[index] as VMediaImageRes).data.fileSource,
                    size: const Size.fromHeight(400),
                  )
                else if (data[index] is VMediaVideoRes)
                  Text(
                      "Video wit thumb ${(data[index] as VMediaVideoRes).data.thumbImage}")
                else
                  Text("File ${data[index].toString()}")
              ],
            );
          },
          itemCount: data.length,
        );
      }),
    );
  }
}
