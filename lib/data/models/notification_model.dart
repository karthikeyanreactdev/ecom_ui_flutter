import 'package:hive/hive.dart';

part 'notification_model.g.dart';

enum NotificationType {
  order,
  promotion,
  account,
  priceAlert,
  general,
}

@HiveType(typeId: 7)
class NotificationModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String body;
  
  @HiveField(3)
  final NotificationType type;
  
  @HiveField(4)
  final bool isRead;
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  final Map<String, dynamic>? data;
  
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });
  
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: _parseNotificationType(json['type']),
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      data: json['data'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'data': data,
    };
  }
  
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
  
  static NotificationType _parseNotificationType(String? type) {
    switch (type) {
      case 'order':
        return NotificationType.order;
      case 'promotion':
        return NotificationType.promotion;
      case 'account':
        return NotificationType.account;
      case 'priceAlert':
        return NotificationType.priceAlert;
      default:
        return NotificationType.general;
    }
  }
}

@HiveType(typeId: 8)
class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 8;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.order;
      case 1:
        return NotificationType.promotion;
      case 2:
        return NotificationType.account;
      case 3:
        return NotificationType.priceAlert;
      default:
        return NotificationType.general;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.order:
        writer.writeByte(0);
        break;
      case NotificationType.promotion:
        writer.writeByte(1);
        break;
      case NotificationType.account:
        writer.writeByte(2);
        break;
      case NotificationType.priceAlert:
        writer.writeByte(3);
        break;
      case NotificationType.general:
        writer.writeByte(4);
        break;
    }
  }
}