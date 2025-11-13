enum MessageType { user, ai }

class Message {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      type: json['type'] == 'user' ? MessageType.user : MessageType.ai,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type == MessageType.user ? 'user' : 'ai',
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
