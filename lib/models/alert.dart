enum AlertLevel { low, medium, high }

class AlertLog {
  final String alertId;
  final String message;
  final DateTime timestamp;
  final AlertLevel alertLevel;

  AlertLog({
    required this.alertId,
    required this.message,
    required this.timestamp,
    required this.alertLevel,
  });

  factory AlertLog.fromJson(Map<String, dynamic> json) {
    return AlertLog(
      alertId: json['alert_id'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      alertLevel: json['level'] as AlertLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alert_id': alertId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'level': alertLevel,
    };
  }
}
