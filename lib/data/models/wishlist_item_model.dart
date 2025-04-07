import 'package:hive/hive.dart';
import 'product_model.dart';

part 'wishlist_item_model.g.dart';

@HiveType(typeId: 2)
class WishlistItemModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String productId;
  
  @HiveField(2)
  final DateTime addedAt;
  
  @HiveField(3)
  ProductModel? product;
  
  WishlistItemModel({
    required this.id,
    required this.productId,
    required this.addedAt,
    this.product,
  });
  
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      productId: json['product'],
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
      product: json['productData'] != null
          ? ProductModel.fromJson(json['productData'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': productId,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
