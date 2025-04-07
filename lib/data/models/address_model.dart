import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 3)
class AddressModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String addressLine1;
  
  @HiveField(4)
  final String? addressLine2;
  
  @HiveField(5)
  final String city;
  
  @HiveField(6)
  final String state;
  
  @HiveField(7)
  final String postalCode;
  
  @HiveField(8)
  final String country;
  
  @HiveField(9)
  final String phone;
  
  @HiveField(10)
  final bool isDefault;
  
  @HiveField(11)
  final String type;
  
  @HiveField(12)
  final String? landmark;
  
  @HiveField(13)
  final DateTime createdAt;
  
  @HiveField(14)
  final DateTime updatedAt;
  
  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
    required this.isDefault,
    required this.type,
    this.landmark,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      userId: json['user'],
      name: json['name'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'].toString(),
      country: json['country'],
      phone: json['phone'],
      isDefault: json['isDefault'] ?? false,
      type: json['type'] ?? 'home',
      landmark: json['landmark'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'phone': phone,
      'isDefault': isDefault,
      'type': type,
      'landmark': landmark,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  String get fullAddress {
    final line2 = addressLine2 != null && addressLine2!.isNotEmpty
        ? ', $addressLine2'
        : '';
    return '$addressLine1$line2, $city, $state $postalCode, $country';
  }
}
