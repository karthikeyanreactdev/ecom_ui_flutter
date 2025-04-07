import 'package:hive/hive.dart';
import 'product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel {
  @HiveField(0)
  final String productId;
  
  @HiveField(1)
  final int quantity;
  
  @HiveField(2)
  final ProductModel product;
  
  @HiveField(3)
  final String? color;
  
  @HiveField(4)
  final String? size;
  
  @HiveField(5)
  final DateTime addedAt;
  
  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.product,
    this.color,
    this.size,
    DateTime? addedAt,
  }) : this.addedAt = addedAt ?? DateTime.now();
  
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      quantity: json['quantity'],
      product: ProductModel.fromJson(json['product']),
      color: json['color'],
      size: json['size'],
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'product': product.toJson(),
      'color': color,
      'size': size,
      'addedAt': addedAt.toIso8601String(),
    };
  }
  
  double get itemTotal => product.price * quantity;
  
  bool get isOnSale => product.isOnSale;
  
  double get discountAmount {
    if (isOnSale && product.compareAtPrice != null) {
      return (product.compareAtPrice! - product.price) * quantity;
    }
    return 0.0;
  }
  
  double? get discountedPrice {
    if (isOnSale && product.compareAtPrice != null) {
      return product.price;
    }
    return null;
  }
  
  CartItemModel copyWith({
    String? productId,
    int? quantity,
    ProductModel? product,
    String? color,
    String? size,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      color: color ?? this.color,
      size: size ?? this.size,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
