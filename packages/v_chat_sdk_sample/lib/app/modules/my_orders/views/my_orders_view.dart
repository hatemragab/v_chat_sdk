import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/order.model.dart';
import 'package:v_chat_sdk_sample/app/core/widgets/app_btn.dart';

import '../../../core/platfrom_widgets/platform_cache_image_widget.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FirestorePagination(
          isLive: true,
          viewType: ViewType.list,
          limit: 20,
          query: FirebaseFirestore.instance
              .collection('orders')
              .orderBy("createdAt", descending: true),
          itemBuilder: (context, documentSnapshot, index) {
            final order = OrderModel.fromMap(
                documentSnapshot.data() as Map<String, dynamic>);
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: PlatformCacheImageWidget(
                  source: order.productModel.imgAsPlatformSource,
                  fit: BoxFit.cover,
                  size: Size(60, 60),
                ),
              ),
              title: Text(order.productModel.title),
              subtitle: Text(order.productModel.desc),
              trailing: AppBtn(
                heroTag: "${DateTime.now().microsecondsSinceEpoch}",
                onPress: controller.chatNow,
                title: "Chat now",
              ),
            );
          },
        ),
      ),
    );
  }
}
