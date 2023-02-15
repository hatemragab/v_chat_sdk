// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import '../clould/cloud_firestore_api.dart';
// import '../models/user.model.dart';
//
// class UserRepository {
//   final CloudFireStoreApi apiClient;
//
//   UserRepository({required this.apiClient});
//
//   Future<List<UserModel>> getAll() async {
//     final result = await apiClient.getCollection();
//     return result.docs
//         .map((json) => UserModel.fromMap(json.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   Stream<List<UserModel>> getStreamAll() {
//     return apiClient.getStreamCollection().map((query) => query.docs
//         .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
//         .toList());
//   }
//
//   Future<UserModel> getId(String id) async {
//     final json = await apiClient.getDocument(id);
//
//     return UserModel.fromMap(json.data()!);
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
//   Future add(UserModel obj) {
//     return apiClient.postDocument(obj.toMap(), id: obj.id);
//   }
// }
