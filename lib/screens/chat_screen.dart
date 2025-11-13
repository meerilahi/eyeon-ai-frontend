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
  late Future<List<Message>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = context.read<ChatController>().fetchMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().connect();
    });
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
            child: FutureBuilder<List<Message>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
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
                  );
                } else {
                  return const Center(child: Text('No messages found'));
                }
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
