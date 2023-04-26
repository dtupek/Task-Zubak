import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Email {
  @HiveField(0)
  final List<String> recipient;
  @HiveField(1)
  final double price;
  final String? message;
  final String? fcmToken;

  Email({
    required this.recipient,
    required this.price,
    this.message,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() => _$EmailToJson(this);
}
