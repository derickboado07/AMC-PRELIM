import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../services/financial_advisor_service.dart'; // ← NEW
import '../services/bible_commentary_service.dart'; // McArthur Bible Commentary
import '../services/relationship_expert_service.dart'; // ← NEW
import '../services/wellness_coach_service.dart'; // ← NEW
import '../main.dart'; // For Persona class

class ChatScreen extends StatefulWidget {
  final Persona persona;

  const ChatScreen({super.key, required this.persona});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void addMessage(String text, String role) {
    setState(() {
      messages.add(
        ChatMessage(
          text: text,
          role: role, // "user" or "model"
          timestamp: DateTime.now(),
        ),
      );
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 🔥 MULTI-TURN HANDLER
  Future<void> handleSend(String text) async {
    // Add user message
    addMessage(text, "user");

    setState(() => _isLoading = true);

    try {
      // 🔥 SEND ENTIRE HISTORY TO GEMINI BASED ON PERSONA
      String aiResponse;
      if (widget.persona.name == 'Financial Advisor') {
        aiResponse = await FinancialAdvisorService.sendMultiTurnMessage(
          messages,
        );
      } else if (widget.persona.name == 'Relationship Expert') {
        aiResponse = await RelationshipExpertService.sendMultiTurnMessage(
          messages,
        );
      } else if (widget.persona.name == 'Wellness Coach') {
        aiResponse = await WellnessCoachService.sendMultiTurnMessage(
          messages,
        );
        } else if (widget.persona.name == 'McArthur Bible Commentary') {
          aiResponse = await BibleCommentaryService.sendMultiTurnMessage(
            messages,
          );
      } else {
        aiResponse = 'This persona is not yet implemented.';
      }

      // Add AI response
      addMessage(aiResponse, "model"); // ← role: "model"
    } catch (e) {
      addMessage('❌ Error: $e', "model");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.persona.name == 'Financial Advisor'
              ? 'Wealth Wise AI'
              : widget.persona.name == 'Relationship Expert'
                  ? 'Relationship Advice AI'
                  : widget.persona.name == 'Wellness Coach'
                      ? 'Wellness Coach AI'
                      : widget.persona.name == 'McArthur Bible Commentary'
                          ? 'McArthur Bible Commentary'
                          : widget.persona.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat, size: 100, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Start chatting!'),
                        Text(
                          'Multi-turn means Gemini remembers context 🧠',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return MessageBubble(message: msg);
                    },
                  ),
          ),

          // Loading
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('🤖 Thinking with context...'),
                ],
              ),
            ),

          // Input
          InputBar(onSendMessage: handleSend),
        ],
      ),
    );
  }
}
