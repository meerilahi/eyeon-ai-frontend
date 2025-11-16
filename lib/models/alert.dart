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
      timestamp: DateTime.parse(json['created_at'] as String),
      alertLevel: json['level'].toString().toLowerCase() == "low"
          ? AlertLevel.low
          : json['level'].toString().toLowerCase() == "medium"
          ? AlertLevel.medium
          : AlertLevel.high,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alert_id': alertId,
      'message': message,
      'created_at': timestamp.toIso8601String(),
      'level': alertLevel.toString(),
    };
  }
}
