import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String phone;
  
  @HiveField(4)
  final String? avatar;
  
  @HiveField(5)
  final List<String>? addresses;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final DateTime updatedAt;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      addresses: json['addresses'] != null
          ? List<String>.from(json['addresses'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  // Derived properties to support the code that expects firstName and lastName
  String get firstName {
    final nameComponents = name.split(' ');
    return nameComponents.isNotEmpty ? nameComponents.first : '';
  }
  
  String get lastName {
    final nameComponents = name.split(' ');
    return nameComponents.length > 1 
        ? nameComponents.sublist(1).join(' ') 
        : '';
  }
  
  // Factory method to create from separate first and last name
  factory UserModel.fromFirstLastName({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    String? avatar,
    List<String>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      name: '$firstName $lastName'.trim(),
      email: email,
      phone: phone,
      avatar: avatar,
      addresses: addresses,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  // CopyWith method to create a new instance with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    List<String>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
