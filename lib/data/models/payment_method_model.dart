import 'package:hive/hive.dart';

part 'payment_method_model.g.dart';

@HiveType(typeId: 7)
class PaymentMethodModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String cardType;
  
  @HiveField(2)
  final String cardNumber;
  
  @HiveField(3)
  final String cardholderName;
  
  @HiveField(4)
  final String expiryDate;
  
  @HiveField(5)
  final bool isDefault;
  
  PaymentMethodModel({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    this.isDefault = false,
  });
  
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      cardType: json['cardType'],
      cardNumber: json['cardNumber'],
      cardholderName: json['cardholderName'],
      expiryDate: json['expiryDate'],
      isDefault: json['isDefault'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'cardholderName': cardholderName,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
    };
  }
  
  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }
  
  String getCardTypeIcon() {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'assets/icons/visa.png';
      case 'mastercard':
        return 'assets/icons/mastercard.png';
      case 'amex':
      case 'american express':
        return 'assets/icons/amex.png';
      case 'discover':
        return 'assets/icons/discover.png';
      default:
        return 'assets/icons/credit_card.png';
    }
  }
}