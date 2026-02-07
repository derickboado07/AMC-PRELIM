import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../widgets/suggestion_chip.dart';
import '../services/financial_advisor_service.dart';
import '../services/psychiatrist_service.dart';
import '../services/relationship_expert_service.dart';
import '../services/wellness_coach_service.dart';
import '../services/bible_commentary_service.dart';
import '../main.dart'; // For Persona class
import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final Persona persona;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ChatScreen({super.key, required this.persona, required this.toggleTheme, required this.isDarkMode});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();
  bool _isLoading = false;

  // 💡 Suggestion prompts based on persona
  late List<String> _suggestions = _getSuggestions();

  List<String> _getSuggestions() {
    switch (widget.persona.name) {
      case 'Financial Advisor':
        return [
          'How should I start investing?',
          'Help me create a budget plan',
          'What\'s the best savings strategy?',
          'Explain passive income for me',
        ];
      case 'Wellness Coach':
        return [
          'Design a workout routine for me',
          'What\'s a good nutrition plan?',
          'Help me create healthy habits',
          'Suggest a stress management routine',
        ];
      case 'Psychiatrist':
        return [
          'I need help managing anxiety',
          'How do I improve my sleep?',
          'Can we discuss my stress levels?',
          'Tips for better mental health',
        ];
      case 'Relationship Expert':
        return [
          'How to improve communication?',
          'Tips for resolving conflicts',
          'How to build trust in relationships?',
          'Advice for long-distance relationships',
        ];
      case 'McArthur Bible Commentary':
        return [
          'Explain this Bible verse to me',
          'What\'s the historical context here?',
          'Help me understand this passage',
          'What\'s the theological meaning?',
        ];
      default:
        return [
          'Can you help me with this?',
          'Tell me more about this',
          'What\'s your perspective?',
          'Give me some advice',
        ];
    }
  }

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
          role: role,
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

  Future<void> handleSend(String text) async {
    // Add user message
    addMessage(text, "user");

    setState(() => _isLoading = true);

    try {
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
        aiResponse = await WellnessCoachService.sendMultiTurnMessage(messages);
      } else if (widget.persona.name == 'Psychiatrist') {
        aiResponse = await PsychiatristService.sendMultiTurnMessage(messages);
      } else if (widget.persona.name == 'McArthur Bible Commentary') {
        aiResponse = await BibleCommentaryService.sendMultiTurnMessage(
          messages,
        );
      } else {
        aiResponse = 'This persona is not yet implemented.';
      }

      addMessage(aiResponse, "model");
    } catch (e) {
      addMessage('❌ Error: $e', "model");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 📱 Get persona display name
  String get _personaDisplayName {
    return widget.persona.name == 'Financial Advisor'
        ? 'Wealth Wise AI'
        : widget.persona.name == 'Relationship Expert'
            ? 'Relationship Advisor'
            : widget.persona.name == 'Wellness Coach'
                ? 'Wellness Coach'
                : widget.persona.name == 'Psychiatrist'
                    ? 'Mental Health AI'
                    : widget.persona.name == 'McArthur Bible Commentary'
                        ? 'Bible Commentary'
                        : widget.persona.name;
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.of(context);

    return Scaffold(
      backgroundColor: palette.backgroundColor,
      // 🎚️ Custom Header instead of AppBar
      body: CustomScrollView(
        slivers: [
          // 📌 Modern Header (fixed-size title so it doesn't scale on scroll)
          SliverAppBar(
            backgroundColor: palette.surfaceColor,
            foregroundColor: palette.textPrimary,
            elevation: 0,
            pinned: true,
            toolbarHeight: 96,
            titleSpacing: 0,
            // Styled circular back button to improve visibility
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Material(
                color: palette.surfaceColor,
                shape: const CircleBorder(),
                elevation: 6,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: palette.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Material(
                  color: palette.surfaceColor,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: widget.toggleTheme,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode, color: palette.primaryColor),
                    ),
                  ),
                ),
              ),
            ],
            // Fixed title row (will not scale when the appbar collapses)
            title: Row(
              children: [
                const SizedBox(width: 8),
                // small avatar kept in the toolbar so layout remains stable
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: palette.primaryGradient,
                    boxShadow: palette.cardShadow,
                  ),
                  child: Icon(
                    widget.persona.icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _personaDisplayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Online • Always ready to help',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: palette.dividerColor,
              ),
            ),
          ),

          // 💬 Messages List or Empty State
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                // 📬 Messages
                Expanded(
                  child: messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.paddingMD,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            return MessageBubble(
                              message: msg,
                              index: index,
                            );
                          },
                        ),
                ),

                // ⏳ Loading Indicator
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingLG),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: AppTheme.paddingMD),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              palette.primaryColor,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Text(
                          'Thinking with context...',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: palette.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      // 📤 Floating Input Bar at Bottom (use bottomNavigationBar so content isn't covered)
      bottomNavigationBar: SafeArea(
        child: InputBar(onSendMessage: handleSend),
      ),
    );
  }

  /// 🎯 Empty State with Suggestion Chips
  Widget _buildEmptyState() {
    final palette = AppTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 🎨 Illustration/Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: palette.primaryGradient,
            boxShadow: palette.cardShadow,
          ),
          child: Icon(
            widget.persona.icon,
            size: 64,
            color: Colors.white,
          ),
        ),
        const Gap(24),
        // 📝 Greeting Title
        Text(
          'Start the Conversation',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        const Gap(8),
        // 📄 Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingXL),
          child: Text(
            'Ask me anything and I\'ll help you with your question',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
        ),
        const Gap(32),
        // 💡 Suggestion Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingLG),
          child: Wrap(
            spacing: AppTheme.paddingMD,
            runSpacing: AppTheme.paddingMD,
            alignment: WrapAlignment.center,
            children: List.generate(
              _suggestions.length,
              (index) => SuggestionChip(
                label: _suggestions[index],
                onTap: () => handleSend(_suggestions[index]),
                index: index,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
