import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String title;
  final DateTime? lastUpdated;
  final String previewText;

  Conversation({
    required this.id,
    required this.title,
    required this.lastUpdated,
    required this.previewText,
  });

  factory Conversation.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ts = data['last_updated'];
    DateTime? last;
    if (ts is Timestamp) last = ts.toDate();
    return Conversation(
      id: doc.id,
      title: (data['title'] as String?) ?? 'New Chat',
      lastUpdated: last,
      previewText: (data['preview_text'] as String?) ?? '',
    );
  }
}

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _conversationsColl(String userId, String personaId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('personas')
        .doc(personaId)
        .collection('conversations');
  }

  /// Creates and returns a fresh conversation id and document.
  Future<String> startNewChat({required String userId, required String personaId}) async {
    final coll = _conversationsColl(userId, personaId);
    final docRef = coll.doc();
    await docRef.set({
      'title': 'New Chat',
      'last_updated': FieldValue.serverTimestamp(),
      'preview_text': '',
    });
    return docRef.id;
  }

  /// Returns a stream of conversation summaries for the current persona.
  Stream<List<Conversation>> getHistory({required String userId, required String personaId}) {
    final coll = _conversationsColl(userId, personaId).orderBy('last_updated', descending: true);
    return coll.snapshots().map((snap) => snap.docs.map((d) => Conversation.fromDoc(d)).toList());
  }

  /// Returns a stream of messages for a given conversation.
  Stream<List<Map<String, dynamic>>> getMessages({
    required String userId,
    required String personaId,
    required String conversationId,
  }) {
    final messagesColl = _conversationsColl(userId, personaId).doc(conversationId).collection('messages').orderBy('created_at');
    return messagesColl.snapshots().map((snap) => snap.docs.map((d) {
          final data = d.data() as Map<String, dynamic>;
          return {
            'id': d.id,
            ...data,
          };
        }).toList());
  }

  /// Sends a message into `conversationId`. If `conversationId` is null or empty,
  /// a new conversation document is created first. The conversation document is
  /// updated with `last_updated` and `preview_text`. If the conversation had
  /// a placeholder title, a simple summary is generated from the first message.
  Future<String> sendMessage({
    required String userId,
    required String personaId,
    String? conversationId,
    required String senderId,
    required String role,
    required String content,
    Map<String, dynamic>? extras,
  }) async {
    final coll = _conversationsColl(userId, personaId);

    DocumentReference conversationRef;
    if (conversationId == null || conversationId.isEmpty) {
      conversationRef = coll.doc();
      // create placeholder conversation; title will be improved below
      await conversationRef.set({
        'title': 'New Chat',
        'last_updated': FieldValue.serverTimestamp(),
        'preview_text': content,
      });
      conversationId = conversationRef.id;
    } else {
      conversationRef = coll.doc(conversationId);
    }

    final messagesColl = conversationRef.collection('messages');
    final messageRef = messagesColl.doc();

    final batch = _db.batch();
    batch.set(messageRef, {
      'sender_id': senderId,
      'role': role,
      'content': content,
      'created_at': FieldValue.serverTimestamp(),
      ...?extras,
    });

    // Update conversation summary fields.
    // If title is default or missing, generate a short title from content.
    final convSnapshot = await conversationRef.get();
    String updatedTitle = 'Conversation';
    final convData = convSnapshot.data() as Map<String, dynamic>?;
    final existingTitle = convData != null ? (convData['title'] as String?) : null;
    final shouldGenerateTitle = existingTitle == null || existingTitle == '' || existingTitle == 'New Chat';
    if (shouldGenerateTitle) {
      // generate a compact title from the message (first line or up to 40 chars)
      final firstLine = content.split('\n').first.trim();
      updatedTitle = firstLine.length <= 40 ? firstLine : '${firstLine.substring(0, 37)}...';
    } else {
      updatedTitle = existingTitle!;
    }

    batch.set(conversationRef, {
      'title': updatedTitle,
      'last_updated': FieldValue.serverTimestamp(),
      'preview_text': content,
    }, SetOptions(merge: true));

    await batch.commit();
    return conversationId;
  }
}
