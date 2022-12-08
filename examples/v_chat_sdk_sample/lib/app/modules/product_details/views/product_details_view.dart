import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductDetailsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ProductDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
