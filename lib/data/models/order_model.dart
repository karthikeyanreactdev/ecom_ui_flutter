import 'package:hive/hive.dart';
import 'address_model.dart';
import 'cart_item_model.dart';

part 'order_model.g.dart';

@HiveType(typeId: 6)
class OrderModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final List<CartItemModel> items;
  
  @HiveField(3)
  final AddressModel shippingAddress;
  
  @HiveField(4)
  final String paymentMethod;
  
  @HiveField(5)
  final String status;
  
  @HiveField(6)
  final double subtotal;
  
  @HiveField(7)
  final double shipping;
  
  @HiveField(8)
  final double tax;
  
  @HiveField(9)
  final double discount;
  
  @HiveField(10)
  final double total;
  
  @HiveField(11)
  final String? trackingNumber;
  
  @HiveField(12)
  final String? couponCode;
  
  @HiveField(13)
  final String? notes;
  
  @HiveField(14)
  final DateTime createdAt;
  
  @HiveField(15)
  final DateTime updatedAt;
  
  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    this.trackingNumber,
    this.couponCode,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      userId: json['user'],
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      shippingAddress: AddressModel.fromJson(json['shippingAddress']),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      subtotal: json['subtotal'].toDouble(),
      shipping: json['shipping'].toDouble(),
      tax: json['tax'].toDouble(),
      discount: json['discount'].toDouble(),
      total: json['total'].toDouble(),
      trackingNumber: json['trackingNumber'],
      couponCode: json['couponCode'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'status': status,
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'discount': discount,
      'total': total,
      'trackingNumber': trackingNumber,
      'couponCode': couponCode,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  bool get canCancel {
    return status == 'pending' || status == 'processing';
  }
  
  bool get canReturn {
    return status == 'delivered';
  }
  
  bool get isDelivered {
    return status == 'delivered';
  }
  
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
