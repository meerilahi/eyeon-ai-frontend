import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';
import '../utils/app_constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String _url = AppConstants.websocketUrl;
  StreamController<Message>? _messageController;
  final User? _user;

  WebSocketService(this._user);

  String get _userId => _user?.id ?? "";

  Stream<Message> connect() {
    debugPrint("WebSocketService: Connecting to $_url as user $_userId");
    _messageController = StreamController<Message>.broadcast();

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      _channel!.stream.listen(
        (data) {
          final aiMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: MessageType.ai,
            content: data.toString(),
            timestamp: DateTime.now(),
          );
          _messageController?.add(aiMessage);
        },
        onError: (error) {
          debugPrint("WebSocketService Error: $error");
          _messageController?.addError(error);
        },
        onDone: () {
          debugPrint("WebSocketService: Connection closed");
          _messageController?.close();
        },
      );
    } catch (e) {
      debugPrint("WebSocketService: Connection failed: $e");
      _messageController?.addError(e);
    }

    return _messageController!.stream;
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.user,
        content: message,
        timestamp: DateTime.now(),
      );
      _messageController?.add(userMessage);
    } else {
      debugPrint("WebSocketService: Not connected, cannot send message");
    }
  }

  void disconnect() {
    try {
      _channel?.sink.close();
      _messageController?.close();
    } catch (e) {
      debugPrint("WebSocketService: Error during disconnect: $e");
    }
  }
}
