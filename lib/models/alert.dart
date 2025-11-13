class Alert {
  final String id;
  final String cameraId;
  final String eventId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  Alert({
    required this.id,
    required this.cameraId,
    required this.eventId,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      cameraId: json['camera_id'] as String,
      eventId: json['event_id'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'camera_id': cameraId,
      'event_id': eventId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
