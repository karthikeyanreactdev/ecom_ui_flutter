// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 4;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      compareAtPrice: fields[4] as double?,
      images: (fields[5] as List).cast<String>(),
      colors: (fields[6] as List?)?.cast<String>(),
      sizes: (fields[7] as List?)?.cast<String>(),
      quantity: fields[8] as int,
      categoryId: fields[9] as String,
      sellerId: fields[10] as String,
      sellerName: fields[11] as String?,
      rating: fields[12] as double,
      reviewCount: fields[13] as int,
      isFeatured: fields[14] as bool,
      isNewArrival: fields[15] as bool,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
      brand: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.compareAtPrice)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.colors)
      ..writeByte(7)
      ..write(obj.sizes)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.categoryId)
      ..writeByte(10)
      ..write(obj.sellerId)
      ..writeByte(11)
      ..write(obj.sellerName)
      ..writeByte(12)
      ..write(obj.rating)
      ..writeByte(13)
      ..write(obj.reviewCount)
      ..writeByte(14)
      ..write(obj.isFeatured)
      ..writeByte(15)
      ..write(obj.isNewArrival)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.brand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
