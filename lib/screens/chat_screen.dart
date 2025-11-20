import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/chat_controller.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().connect();
    });
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatController = context.watch<ChatController>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: chatController.messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                      itemCount: chatController.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatController.messages[index];
                        final isUser = message.type == MessageType.user;
                        return _buildMessageBubble(message, isUser);
                      },
                    ),
            ),
            _buildInputBar(chatController),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(ChatController chatController) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25),
        bottom: Radius.circular(25),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white.withOpacity(0.6),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        chatController.sendMessage(value);
                        _messageController.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildSendButton(chatController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(ChatController chatController) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade700],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        onPressed: () {
          if (_messageController.text.isNotEmpty) {
            chatController.sendMessage(_messageController.text);
            _messageController.clear();
            _scrollToBottom();
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 24),
          const Text(
            'Start a Conversation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ask me anything about your security system',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.red.shade300,
                  size: 20,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.red.shade600
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (!isUser) const SizedBox(height: 8),
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.red.shade300,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
