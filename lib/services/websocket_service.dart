import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/message.dart';

class WebSocketService {
  // WebSocketChannel? _channel;
  // final String _url = AppConstants.websocketUrl; // Commented out - no server available
  StreamController<Message>? _messageController;
  Timer? _simulationTimer;

  Stream<Message> connect() {
    debugPrint('WebSocketService: Simulating connection (no server available)');
    _messageController = StreamController<Message>.broadcast();

    // Simulate some initial chat history
    _simulateChatHistory();

    // Simulate periodic AI responses
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _simulateAIResponse();
    });

    return _messageController!.stream;
  }

  void _simulateChatHistory() {
    // Simulate some initial messages
    final messages = [
      Message(
        id: '1',
        type: MessageType.user,
        content: 'Hello, can you help me monitor my cameras?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        type: MessageType.ai,
        content:
            'Hello! I\'m your AI assistant. I can help you monitor your cameras and alert you to any unusual activity. What would you like to know?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      Message(
        id: '3',
        type: MessageType.user,
        content: 'How many cameras do I have active?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Message(
        id: '4',
        type: MessageType.ai,
        content:
            'You currently have 3 cameras active in your system. All are functioning normally and no alerts have been detected in the last hour.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];

    for (final message in messages) {
      _messageController?.add(message);
    }
  }

  void _simulateAIResponse() {
    final responses = [
      'I\'m monitoring your cameras continuously. Everything looks normal.',
      'No unusual activity detected in the last few minutes.',
      'Your security system is active and all cameras are online.',
      'I\'ve checked the recent footage - everything appears secure.',
      'Would you like me to check a specific camera or area?',
    ];

    final randomResponse =
        responses[DateTime.now().millisecondsSinceEpoch % responses.length];

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: randomResponse,
      timestamp: DateTime.now(),
    );

    _messageController?.add(message);
  }

  void sendMessage(String message) {
    debugPrint('WebSocketService: Simulating send message: $message');
    // Simulate AI response after user sends message
    Future.delayed(const Duration(seconds: 1), () {
      final responses = [
        'I received your message: "$message". How can I help you further?',
        'Thanks for your message. I\'m here to assist with your security monitoring.',
        'Got it! I\'m processing your request about: $message',
        'Message received. Let me help you with that.',
      ];

      final randomResponse =
          responses[DateTime.now().millisecondsSinceEpoch % responses.length];

      final aiMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.ai,
        content: randomResponse,
        timestamp: DateTime.now(),
      );

      _messageController?.add(aiMessage);
    });
  }

  void disconnect() {
    debugPrint('WebSocketService: Simulating disconnect');
    _simulationTimer?.cancel();
    _messageController?.close();
    debugPrint('WebSocketService: Disconnected');
  }
}
