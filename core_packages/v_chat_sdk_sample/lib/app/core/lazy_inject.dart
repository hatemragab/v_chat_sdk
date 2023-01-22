import 'package:get/get.dart';

class LazyInjection extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<UserRepository>(
    //   () => UserRepository(
    //     apiClient: CloudFireStoreApi(collection: "users"),
    //   ),
    //   fenix: true,
    // );
    // Get.lazyPut<ProductRepository>(
    //   () => ProductRepository(
    //     apiClient: CloudFireStoreApi(collection: "products"),
    //   ),
    //   fenix: true,
    // );
    // Get.lazyPut<OrderRepository>(
    //   () => OrderRepository(
    //     apiClient: CloudFireStoreApi(collection: "orders"),
    //   ),
    //   fenix: true,
    // );
  }
}
