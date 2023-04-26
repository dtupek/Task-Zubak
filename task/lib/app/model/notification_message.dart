class NotificationMessage {
  final String message;
  final DateTime timestamp;

  const NotificationMessage({
    required this.message,
    required this.timestamp,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String).toLocal(),
    );
  }
}
