import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/websocket_service.dart';

class ChatController extends ChangeNotifier {
  WebSocketService? _service;
  ChatController();

  set service(WebSocketService service) => _service = service;

  final List<Message> _messages = [];
  bool _isConnected = false;

  List<Message> get messages => _messages;
  bool get isConnected => _isConnected;

  void connect() {
    if (_isConnected) return;

    _service!.connect().listen((message) {
      _messages.add(message);
      notifyListeners();
    });
    _isConnected = true;
    notifyListeners();
  }

  void sendMessage(String content) {
    if (content.isEmpty) return;

    _service!.sendMessage(content);
    notifyListeners();
  }

  void disconnect() {
    _service!.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  void clearData() {
    _messages.clear();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
