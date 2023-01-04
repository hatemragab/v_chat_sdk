import '../clould/cloud_firestore_api.dart';
import '../models/product.model.dart';

class ProductRepository {
  final CloudFireStoreApi apiClient;

  ProductRepository({required this.apiClient});

  Future<List<ProductModel>> getAll() async {
    final result = await apiClient.getCollection();
    return result.docs
        .map(
            (json) => ProductModel.fromMap(json.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ProductModel>> getStreamAll() {
    return apiClient.getStreamCollection().map((query) => query.docs
        .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  Future<ProductModel> getId(String id) async {
    final json = await apiClient.getDocument(id);

    return ProductModel.fromMap(json.data()!);
  }

  Future delete(String id) {
    return apiClient.deleteDocument(id);
  }

  Future edit(Map<String, dynamic> obj, String id) {
    return apiClient.updateDocument(obj, id);
  }

  Future add(ProductModel obj) {
    return apiClient.postDocument(obj.toMap(), id: obj.productId);
  }
}
