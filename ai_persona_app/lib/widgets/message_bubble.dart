// lib/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import '../models/chat_message.dart'; // Assuming your model is here

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUserMessage = message.isUserMessage;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Colors.blue[300] // User: Brighter blue
              : Colors.green[100], // AI: Green (Gemini!)
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUserMessage ? 20 : 0),
            bottomRight: Radius.circular(isUserMessage ? 0 : 20),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUserMessage
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSecondaryContainer,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
