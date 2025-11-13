class Event {
  final String eventId;
  final String eventDescription;
  final bool isActive;
  final DateTime createdAt;

  Event({
    required this.eventId,
    required this.eventDescription,
    required this.isActive,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] as String,
      eventDescription: json['event_description'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'event_description': eventDescription,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
