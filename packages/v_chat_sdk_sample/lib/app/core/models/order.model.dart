import 'package:v_chat_sdk_sample/app/core/models/product.model.dart';

class OrderModel {
  final String id;
  final ProductModel productModel;
  final String userId;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">

  const OrderModel({
    required this.id,
    required this.productModel,
    required this.userId,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productModel == other.productModel &&
          userId == other.userId &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      productModel.hashCode ^
      userId.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'OrderModel{ id: $id, productModel: $productModel, userId: $userId, createdAt: $createdAt,}';
  }

  OrderModel copyWith({
    String? id,
    ProductModel? productModel,
    String? userId,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      productModel: productModel ?? this.productModel,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productModel': productModel.toMap(),
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      productModel: ProductModel.fromMap(map['productModel']),
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

//</editor-fold>
}
