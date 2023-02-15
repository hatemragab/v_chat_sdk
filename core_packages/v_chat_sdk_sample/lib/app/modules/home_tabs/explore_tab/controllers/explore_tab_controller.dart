// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class ExploreTabController extends GetxController {
  // final ProductRepository repository;

  // ExploreTabController(this.repository);

  void onCreateProduct() {
    Get.toNamed(Routes.CREATE_PRODUCT);
  }
}
