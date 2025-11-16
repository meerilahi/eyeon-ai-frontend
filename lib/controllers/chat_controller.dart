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
    debugPrint('ChatController: Connecting to WebSocket');
    _webSocketService.connect().listen((message) {
      debugPrint('ChatController: Received message: ${message.content}');
      _messages.add(message);
      notifyListeners();
    });
    _isConnected = true;
    notifyListeners();
  }

  void sendMessage(String content) {
    debugPrint('ChatController: Sending message: $content');
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
    debugPrint('ChatController: Disconnecting from WebSocket');
    _webSocketService.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  Future<List<Message>> fetchMessages() async {
    debugPrint('ChatController: Fetching messages from Supabase');
    try {
      final messages = await _supabaseService.getMessages();
      debugPrint('ChatController: Fetched ${messages.length} messages');
      return messages;
    } catch (e) {
      debugPrint('ChatController: Error fetching messages: $e');
      rethrow;
    }
  }

  void clearData() {
    debugPrint('ChatController: Clearing data');
    _messages.clear();
    _isConnected = false;
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
