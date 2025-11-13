import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/chat_controller.dart';
import '../models/message.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatController>().connect();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = context.watch<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI Agent'),
        actions: [
          IconButton(
            icon: Icon(
              chatController.isConnected ? Icons.wifi : Icons.wifi_off,
            ),
            onPressed: () {
              if (chatController.isConnected) {
                chatController.disconnect();
              } else {
                chatController.connect();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(message.timestamp.toString()),
                  leading: Icon(
                    message.type == MessageType.user
                        ? Icons.person
                        : Icons.smart_toy,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    label: 'Type your message',
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Send',
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      chatController.sendMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
