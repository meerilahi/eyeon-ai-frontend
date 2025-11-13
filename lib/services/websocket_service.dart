import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String _url =
      'ws://localhost:8000/chat'; // Replace with actual backend URL

  Stream<Message> connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    return _channel!.stream.map((data) {
      final json = jsonDecode(data as String);
      return Message(
        id: json['id'] ?? '',
        type: MessageType.ai,
        content: json['content'] ?? '',
        timestamp: DateTime.now(),
      );
    });
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({'type': 'user_message', 'content': message}),
      );
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
