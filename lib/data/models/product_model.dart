import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 4)
class ProductModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final double? compareAtPrice;
  
  @HiveField(5)
  final List<String> images;
  
  @HiveField(6)
  final List<String>? colors;
  
  @HiveField(7)
  final List<String>? sizes;
  
  @HiveField(8)
  final int quantity;
  
  @HiveField(9)
  final String categoryId;
  
  @HiveField(10)
  final String sellerId;
  
  @HiveField(11)
  final String? sellerName;
  
  @HiveField(12)
  final double rating;
  
  @HiveField(13)
  final int reviewCount;
  
  @HiveField(14)
  final bool isFeatured;
  
  @HiveField(15)
  final bool isNewArrival;
  
  @HiveField(16)
  final DateTime createdAt;
  
  @HiveField(17)
  final DateTime updatedAt;
  
  @HiveField(18)
  final String? brand;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.compareAtPrice,
    required this.images,
    this.colors,
    this.sizes,
    required this.quantity,
    required this.categoryId,
    required this.sellerId,
    this.sellerName,
    required this.rating,
    required this.reviewCount,
    required this.isFeatured,
    required this.isNewArrival,
    required this.createdAt,
    required this.updatedAt,
    this.brand,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      compareAtPrice: json['compareAtPrice']?.toDouble(),
      images: List<String>.from(json['images']),
      colors: json['colors'] != null
          ? List<String>.from(json['colors'])
          : null,
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'])
          : null,
      quantity: json['quantity'],
      categoryId: json['categoryId'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      isNewArrival: json['isNewArrival'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      brand: json['brand'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'images': images,
      'colors': colors,
      'sizes': sizes,
      'quantity': quantity,
      'categoryId': categoryId,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'brand': brand,
    };
  }
  
  bool get isOnSale => compareAtPrice != null && compareAtPrice! > price;
  
  double get discountPercentage {
    if (isOnSale) {
      return ((compareAtPrice! - price) / compareAtPrice! * 100).roundToDouble();
    }
    return 0.0;
  }
  
  bool get isInStock => quantity > 0;
}
