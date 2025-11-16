import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eyeon_ai_frontend/utils/app_constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String _url = AppConstants.websocketUrl;

  Stream<Message> connect() {
    debugPrint('WebSocketService: Connecting to $_url');
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    return _channel!.stream.map((data) {
      final json = jsonDecode(data as String);
      final message = Message(
        id: json['id'] ?? '',
        type: MessageType.ai,
        content: json['content'] ?? '',
        timestamp: DateTime.now(),
      );
      debugPrint('WebSocketService: Received message: ${message.content}');
      return message;
    });
  }

  void sendMessage(String message) {
    debugPrint('WebSocketService: Sending message: $message');
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({'type': 'user_message', 'content': message}),
      );
      debugPrint('WebSocketService: Sent message');
    } else {
      debugPrint('WebSocketService: Cannot send message, channel is null');
    }
  }

  void disconnect() {
    debugPrint('WebSocketService: Disconnecting');
    _channel?.sink.close();
    debugPrint('WebSocketService: Disconnected');
  }
}
