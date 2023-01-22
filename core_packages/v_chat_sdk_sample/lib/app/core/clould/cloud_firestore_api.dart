//
// class CloudFireStoreApi {
//   final String collection;
//   final FirebaseFirestore fireStore = FirebaseFirestore.instance;
//
//   // collections is required
//   CloudFireStoreApi({required this.collection});
//
//   // STREAM request
//   Stream<QuerySnapshot> getStreamCollection() => fireStore
//       .collection(collection)
//       .orderBy("createdAt", descending: true)
//       .snapshots();
//
//   Stream<DocumentSnapshot> getStreamDocument(String id) =>
//       fireStore.collection(collection).doc(id).snapshots();
//
//   // GET request
//   Future<QuerySnapshot> getCollection() =>
//       fireStore.collection(collection).get();
//
//   Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String id) =>
//       fireStore.collection(collection).doc(id).get();
//
//   // Post request
//   Future<void> postDocument(Map<String, dynamic> obj, {String? id}) async {
//     id != null
//         ? await fireStore.collection(collection).doc(id).set(obj)
//         : await fireStore.collection(collection).doc().set(obj);
//   }
//
//   // update
//   Future<void> updateDocument(Map<String, dynamic> obj, String id) async =>
//       await fireStore.collection(collection).doc(id).update(obj);
//
//   // update
//   Future<void> deleteDocument(String id) async =>
//       await fireStore.collection(collection).doc(id).delete();
//
//   // other Requests
//   // Check If Document Exists
//   Future<bool> checkIfDocExists(String docId) async {
//     try {
//       // Get reference to Firestore collection
//       var collectionRef = fireStore.collection(collection);
//       var doc = await collectionRef.doc(docId).get();
//       return doc.exists;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<bool> checkIfFieldExist(Map<String, dynamic> field) async {
//     try {
//       // Get reference to Firestore collection
//       var collectionRef = fireStore
//           .collection(collection)
//           .where(field["key"], isEqualTo: field["value"]);
//
//       // get only one document from Firestore
//       var doc = await collectionRef.limit(1).get();
//
//       return doc.docs.isEmpty;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
