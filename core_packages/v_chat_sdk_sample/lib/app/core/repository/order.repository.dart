// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import '../clould/cloud_firestore_api.dart';
// import '../models/order.model.dart';
//
// class OrderRepository {
//   final CloudFireStoreApi apiClient;
//
//   OrderRepository({required this.apiClient});
//
//   Future<List<OrderModel>> getAll() async {
//     final result = await apiClient.getCollection();
//     return result.docs
//         .map((json) => OrderModel.fromMap(json.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   Stream<List<OrderModel>> getStreamAll() {
//     return apiClient.getStreamCollection().map((query) => query.docs
//         .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
//         .toList());
//   }
//
//   Future<OrderModel> getId(String id) async {
//     final json = await apiClient.getDocument(id);
//
//     return OrderModel.fromMap(json.data()!);
//   }
//
//   Future delete(String id) {
//     return apiClient.deleteDocument(id);
//   }
//
//   Future edit(Map<String, dynamic> obj, String id) {
//     return apiClient.updateDocument(obj, id);
//   }
//
//   Future add(OrderModel obj) {
//     return apiClient.postDocument(obj.toMap(), id: obj.id);
//   }
// }
