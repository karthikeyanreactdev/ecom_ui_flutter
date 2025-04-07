import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class CategoryModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final String? image;
  
  @HiveField(4)
  final bool isActive;
  
  @HiveField(5)
  final String? parentId;
  
  @HiveField(6)
  final int level;
  
  @HiveField(7)
  final String slug;
  
  @HiveField(8)
  final List<CategoryModel>? subcategories;
  
  @HiveField(9)
  final DateTime createdAt;
  
  @HiveField(10)
  final DateTime updatedAt;
  
  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.isActive,
    this.parentId,
    required this.level,
    required this.slug,
    this.subcategories,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      isActive: json['isActive'] ?? true,
      parentId: json['parentCategory'],
      level: json['level'] ?? 1,
      slug: json['slug'],
      subcategories: json['subcategories'] != null
          ? List<CategoryModel>.from(json['subcategories']
              .map((x) => CategoryModel.fromJson(x)))
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'isActive': isActive,
      'parentCategory': parentId,
      'level': level,
      'slug': slug,
      'subcategories': subcategories?.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
