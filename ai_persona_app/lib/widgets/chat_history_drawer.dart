import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';
import '../theme/app_theme.dart';

typedef ConversationSelected = void Function(String conversationId);

class ChatHistoryDrawer extends StatefulWidget {
  final String userId;
  final String personaId;
  final String? currentConversationId;
  final ConversationSelected onConversationSelected;
  final ChatService chatService;

  ChatHistoryDrawer({
    Key? key,
    required this.userId,
    required this.personaId,
    this.currentConversationId,
    required this.onConversationSelected,
    ChatService? service,
  })  : chatService = service ?? ChatService(),
        super(key: key);

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  String _searchQuery = '';

  String _sectionLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    final diff = today.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff <= 7) return 'Previous 7 Days';
    return 'Older';
  }

  String _timeLabel(DateTime? d) {
    if (d == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(d.year, d.month, d.day);
    if (date == today) return DateFormat.Hm().format(d);
    return DateFormat.yMMMd().format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✨ Modern Header Section
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: AppTheme.cardShadow,
              ),
              padding: const EdgeInsets.all(AppTheme.paddingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat History',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSM),
                  Text(
                    'Your conversations',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLG),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                    borderSide: const BorderSide(
                      color: AppTheme.dividerColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                    borderSide: const BorderSide(
                      color: AppTheme.dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingLG,
                    vertical: AppTheme.paddingMD,
                  ),
                ),
              ),
            ),

            // 📱 New Chat Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingLG),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  'New Chat',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                onPressed: () async {
                  final id = await widget.chatService.startNewChat(
                    userId: widget.userId,
                    personaId: widget.personaId,
                  );
                  widget.onConversationSelected(id);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingLG,
                    vertical: AppTheme.paddingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputBorderRadius),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            // 💬 Conversation History List
            Expanded(
              child: StreamBuilder<List<Conversation>>(
                stream: widget.chatService.getHistory(
                  userId: widget.userId,
                  personaId: widget.personaId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(height: AppTheme.paddingMD),
                          Text(
                            'Error loading history',
                            style: GoogleFonts.lato(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data!;
                  final filtered = _searchQuery.isEmpty
                      ? items
                      : items
                          .where((c) =>
                              c.title.toLowerCase().contains(_searchQuery) ||
                              c.previewText.toLowerCase().contains(_searchQuery))
                          .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(height: AppTheme.paddingMD),
                          Text(
                            'No conversations yet',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.paddingSM),
                          Text(
                            'Start a new chat to begin',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Group by section label
                  final Map<String, List<Conversation>> sections = {};
                  for (final c in filtered) {
                    final label = c.lastUpdated != null ? _sectionLabel(c.lastUpdated!) : 'Older';
                    sections.putIfAbsent(label, () => []).add(c);
                  }

                  final order = ['Today', 'Yesterday', 'Previous 7 Days', 'Older'];
                  final widgets = <Widget>[];

                  for (final section in order) {
                    final list = sections[section];
                    if (list == null) continue;

                    // Section Header
                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.paddingLG,
                          AppTheme.paddingLG,
                          AppTheme.paddingLG,
                          AppTheme.paddingMD,
                        ),
                        child: Text(
                          section,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    );

                    // Conversation Cards
                    for (final conv in list) {
                      widgets.add(
                        _buildConversationCard(context, conv),
                      );
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.only(bottom: AppTheme.paddingLG),
                    children: widgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationCard(BuildContext context, Conversation conv) {
    final isSelected = conv.id == widget.currentConversationId;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingLG,
        vertical: AppTheme.paddingSM,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.onConversationSelected(conv.id);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.3)
                    : AppTheme.dividerColor,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
              boxShadow: isSelected ? AppTheme.mediumShadow : [],
            ),
            padding: const EdgeInsets.all(AppTheme.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with selection indicator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conv.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: AppTheme.paddingSM),
                        child: Icon(
                          Icons.check_circle,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                  ],
                ),

                // Preview Text
                if (conv.previewText.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.paddingSM),
                  Text(
                    conv.previewText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],

                // Time indicator
                Padding(
                  padding: const EdgeInsets.only(top: AppTheme.paddingSM),
                  child: Text(
                    _timeLabel(conv.lastUpdated),
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
