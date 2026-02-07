// lib/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;

  const MessageBubble({
    super.key,
    required this.message,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.isUserMessage;
    final palette = AppTheme.of(context);

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: AppTheme.paddingSM,
          horizontal: AppTheme.paddingMD,
        ),
        child: Column(
          crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // 💬 Message Bubble
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.paddingMD,
                horizontal: AppTheme.paddingLG,
              ),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? palette.userBubbleColor
                    : palette.aiBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUserMessage ? 20 : 4),
                  bottomRight: Radius.circular(isUserMessage ? 4 : 20),
                ),
                boxShadow: isUserMessage
                    ? [
                        BoxShadow(
                          color: palette.primaryColor.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: isUserMessage
                      ? palette.userTextColor
                      : palette.aiTextColor,
                  height: 1.5,
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: 50 * index))
                .slideX(
                  begin: isUserMessage ? 0.3 : -0.3,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                )
                .fadeIn(duration: 300.ms),
          ],
        ),
      ),
    );
  }
}
