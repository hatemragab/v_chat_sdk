import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // final m = controller.productModel;
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(m.title),
    //     centerTitle: true,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           VPlatformCacheImageWidget(
    //             source: m.imgAsPlatformSource,
    //             size: Size(100, MediaQuery.of(context).size.height / 3),
    //             fit: BoxFit.cover,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 const SizedBox(
    //                   height: 10,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Flexible(child: m.title.h6.maxLine(1).overflowEllipsis),
    //                     "${m.price} \$".toString().h6.color(Colors.red)
    //                   ],
    //                 ),
    //                 const SizedBox(
    //                   height: 10,
    //                 ),
    //                 const Divider(),
    //                 m.desc.text,
    //                 const Divider(),
    //                 Center(
    //                   child: Row(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Expanded(
    //                         child: ChatBtn(
    //                           onPress: controller.startChat,
    //                         ),
    //                       ),
    //                       const SizedBox(
    //                         width: 15,
    //                       ),
    //                       Expanded(
    //                         child: FloatingActionButton(
    //                           onPressed: controller.startAddOrder,
    //                           heroTag:
    //                               "${DateTime.now().microsecondsSinceEpoch}",
    //                           child: Row(
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: const [
    //                               Icon(Icons.add),
    //                               SizedBox(
    //                                 width: 5,
    //                               ),
    //                               Text("Place order"),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
