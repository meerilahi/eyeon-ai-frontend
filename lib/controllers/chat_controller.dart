import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/websocket_service.dart';
import '../services/supabase_service.dart';

class ChatController extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  final SupabaseService _supabaseService = SupabaseService();
  final List<Message> _messages = [];
  bool _isConnected = false;

  List<Message> get messages => _messages;
  bool get isConnected => _isConnected;

  void connect() {
    _webSocketService.connect().listen((message) {
      _messages.add(message);
      notifyListeners();
    });
    _isConnected = true;
    notifyListeners();
  }

  void sendMessage(String content) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: content,
      timestamp: DateTime.now(),
    );
    _messages.add(message);
    _webSocketService.sendMessage(content);
    _supabaseService.saveMessage(message); // Optional
    notifyListeners();
  }

  void disconnect() {
    _webSocketService.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  Future<List<Message>> fetchMessages() async {
    return await _supabaseService.getMessages();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
