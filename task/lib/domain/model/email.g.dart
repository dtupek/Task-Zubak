// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmailAdapter extends TypeAdapter<Email> {
  @override
  final int typeId = 1;

  @override
  Email read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Email(
      recipient: (fields[0] as List).cast<String>(),
      price: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Email obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.recipient)
      ..writeByte(1)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Email _$EmailFromJson(Map<String, dynamic> json) => Email(
      recipient:
          (json['recipient'] as List<dynamic>).map((e) => e as String).toList(),
      price: (json['price'] as num).toDouble(),
      message: json['message'] as String,
      fcmToken: json['fcmToken'] as String,
    );

Map<String, dynamic> _$EmailToJson(Email instance) => <String, dynamic>{
      'recipient': instance.recipient,
      'price': instance.price,
      'message': instance.message,
      'fcmToken': instance.fcmToken,
    };
