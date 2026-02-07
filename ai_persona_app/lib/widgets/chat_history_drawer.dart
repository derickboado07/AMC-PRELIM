import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';

typedef ConversationSelected = void Function(String conversationId);

class ChatHistoryDrawer extends StatelessWidget {
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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('New Chat'),
                      onPressed: () async {
                        final id = await chatService.startNewChat(userId: userId, personaId: personaId);
                        onConversationSelected(id);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Conversation>>(
                stream: chatService.getHistory(userId: userId, personaId: personaId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Error loading history'));
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  final items = snapshot.data!;
                  if (items.isEmpty) return Center(child: Text('No conversations'));

                  // Group by section label
                  final Map<String, List<Conversation>> sections = {};
                  for (final c in items) {
                    final label = c.lastUpdated != null ? _sectionLabel(c.lastUpdated!) : 'Older';
                    sections.putIfAbsent(label, () => []).add(c);
                  }

                  final order = ['Today', 'Yesterday', 'Previous 7 Days', 'Older'];
                  final widgets = <Widget>[];
                  for (final section in order) {
                    final list = sections[section];
                    if (list == null) continue;
                    widgets.add(Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text(section, style: Theme.of(context).textTheme.bodySmall),
                    ));
                    for (final conv in list) {
                      widgets.add(ListTile(
                        dense: true,
                        selected: conv.id == currentConversationId,
                        title: Text(conv.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: conv.previewText.isNotEmpty ? Text(conv.previewText, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
                        trailing: Text(_timeLabel(conv.lastUpdated), style: TextStyle(fontSize: 12)),
                        onTap: () {
                          onConversationSelected(conv.id);
                          Navigator.of(context).pop();
                        },
                      ));
                      widgets.add(Divider(height: 1));
                    }
                  }

                  return ListView(children: widgets);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
