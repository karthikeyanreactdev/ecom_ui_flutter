// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 6;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      items: (fields[2] as List).cast<CartItemModel>(),
      shippingAddress: fields[3] as AddressModel,
      paymentMethod: fields[4] as String,
      status: fields[5] as String,
      subtotal: fields[6] as double,
      shipping: fields[7] as double,
      tax: fields[8] as double,
      discount: fields[9] as double,
      total: fields[10] as double,
      trackingNumber: fields[11] as String?,
      couponCode: fields[12] as String?,
      notes: fields[13] as String?,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.shippingAddress)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.subtotal)
      ..writeByte(7)
      ..write(obj.shipping)
      ..writeByte(8)
      ..write(obj.tax)
      ..writeByte(9)
      ..write(obj.discount)
      ..writeByte(10)
      ..write(obj.total)
      ..writeByte(11)
      ..write(obj.trackingNumber)
      ..writeByte(12)
      ..write(obj.couponCode)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
