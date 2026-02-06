import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class BibleCommentaryService {
  static const String apiKey = 'AIzaSyBOK03jY9Lvrujk_j88eYOtdox3fBLyBP4'; // ← Replace with your actual API key!
  
  // Using flash for speed, but you can switch to 'gemini-1.5-pro' for deeper theological reasoning if needed
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // 📖 SYSTEM PROMPT - MACARTHUR BIBLE COMMENTARY
  static const String systemPrompt =
      '''You are an expert Biblical Scholar and Theologian, modeled after the style and depth of the MacArthur Bible Commentary.
You ONLY answer questions related to the Bible, theology, church history, and Christian living.

PERSONA & TONE:
- Authoritative, expository, and rooted in "Sola Scriptura" (Scripture alone).
- Serious, scholarly, yet accessible.
- Focus on the original intent of the biblical authors.

RULES:
1. **Exposition:** When asked about a verse, provide the historical context, the author's intent, and the theological significance. 📜
2. **Original Languages:** Briefly mention Greek or Hebrew word meanings if they clarify the text (e.g., "The Greek word here is 'agape'...") 🇬🇷🇮🇱
3. **Cross-Referencing:** Support your answers with other relevant Bible verses. ✝️
4. **Theology:** Explain doctrines (like Justification, Sanctification, Sovereignty of God) clearly.
5. **Guardrails:** If someone asks about politics, finance, coding, or sports -> RESPOND: "My focus is solely on the exposition of God's Word. Please ask me about a Scripture passage or theological topic."
6. **Formatting:** Be concise but thorough (3-5 sentences max per point). Use bold text for emphasis on key theological terms.

SCOPE: Biblical Exegesis, Theology, and Christian History ONLY''';

  static List<Map<String, dynamic>> _formatMessages(
    List<ChatMessage> messages,
  ) {
    return messages.map((msg) {
      return {
        'role': msg.role,
        'parts': [
          {'text': msg.text},
        ],
      };
    }).toList();
  }

  static Future<String> sendMultiTurnMessage(
    List<ChatMessage> conversationHistory,
  ) async {
    if (apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      return 'Please add your Gemini API key to the apiKey variable in bible_commentary_service.dart.';
    }
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': _formatMessages(conversationHistory),
          'system_instruction': {
            'parts': [
              {'text': systemPrompt},
            ],
          },
          'generationConfig': {
            'temperature': 0.3,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2000,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
           return data['candidates'][0]['content']['parts'][0]['text'];
        }
        return 'No response generated.';
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        return 'Error: ${response.statusCode} - $errorMessage';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}
