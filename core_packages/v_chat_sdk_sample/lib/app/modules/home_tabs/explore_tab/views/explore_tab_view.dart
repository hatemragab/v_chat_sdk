// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/explore_tab_controller.dart';

class ExploreTabView extends GetView<ExploreTabController> {
  const ExploreTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onCreateProduct,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Explore products'),
        centerTitle: true,
      ),
      body: Center(
        child: GetBuilder<ExploreTabController>(builder: (logic) {
          return Text(controller.txt.toString());
        }),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: FirestorePagination(
      //     isLive: true,
      //     viewType: ViewType.grid,
      //     limit: 10,
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2,
      //       crossAxisSpacing: 15,
      //       mainAxisSpacing: 15,
      //     ),
      //     query: FirebaseFirestore.instance
      //         .collection('products')
      //         .orderBy("createdAt", descending: true),
      //     itemBuilder: (context, documentSnapshot, index) {
      //       final product = ProductModel.fromMap(
      //         documentSnapshot.data() as Map<String, dynamic>,
      //       );
      //       return InkWell(
      //         onTap: () => Get.toNamed(
      //           Routes.PRODUCT_DETAILS,
      //           arguments: product,
      //         ),
      //         child: GridTile(
      //           header: Center(
      //             child: Padding(
      //               padding: const EdgeInsets.all(3),
      //               child: Row(
      //                 children: [
      //                   ClipRRect(
      //                     borderRadius: BorderRadius.circular(100),
      //                     child: VPlatformCacheImageWidget(
      //                       source: product.userModel.imgAsPlatformSource,
      //                       size: const Size(30, 30),
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     width: 5,
      //                   ),
      //                   Container(
      //                     padding: const EdgeInsets.all(5),
      //                     decoration: BoxDecoration(
      //                         color: Colors.grey.withOpacity(.5),
      //                         borderRadius: BorderRadius.circular(100)),
      //                     child: product.userModel.userName.text
      //                         .maxLine(1)
      //                         .overflowClip,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           footer: Padding(
      //             padding: const EdgeInsets.all(4),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Center(
      //                   child: Container(
      //                     width: 100,
      //                     padding: const EdgeInsets.all(5),
      //                     decoration: BoxDecoration(
      //                       color: Colors.green.withOpacity(.5),
      //                       borderRadius: BorderRadius.circular(100),
      //                     ),
      //                     child: product.title.text
      //                         .maxLine(1)
      //                         .overflowClip
      //                         .alignCenter,
      //                   ),
      //                 ),
      //                 Container(
      //                   width: 60,
      //                   padding: const EdgeInsets.all(5),
      //                   decoration: BoxDecoration(
      //                       color: Colors.red.withOpacity(.5),
      //                       borderRadius: BorderRadius.circular(100)),
      //                   child: "${product.price} \$"
      //                       .toString()
      //                       .text
      //                       .maxLine(1)
      //                       .overflowClip
      //                       .alignCenter,
      //                 ),
      //               ],
      //             ),
      //           ),
      //           child: VPlatformCacheImageWidget(
      //             source: product.imgAsPlatformSource,
      //             size: const Size(120, 120),
      //             fit: BoxFit.contain,
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
