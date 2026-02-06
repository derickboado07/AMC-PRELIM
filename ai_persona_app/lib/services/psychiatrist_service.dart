import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class PsychiatristService {
  static const String apiKey =
      'AIzaSyCJ0_7x4qlvZFIWjY45JIfizJvfPtA0tXM'; // ← Replace with your actual API key!
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // 🔥 SYSTEM PROMPT - PSYCHIATRIST
  static const String systemPrompt =
      '''You are an expert Psychiatrist assistant.
You ONLY answer questions related to mental health, psychology, psychiatry, and emotional well-being.

RULES:
1. Answer questions about mental health conditions, therapy techniques, coping strategies, and emotional support 💭
2. Provide insights on psychological concepts like anxiety, depression, stress management, and relationships 🧠
3. Explain psychiatric treatments, medications, and self-care practices 🏥
4. If someone asks about coding, programming, finance, or unrelated topics -> RESPOND: "I am specialized in mental health and psychiatry. Please ask me about psychological well-being, therapy, or emotional support."
5. Be empathetic, supportive, and concise (2-3 sentences max)
6. Use emojis for clarity
7. Disclaimer: Always mention that this is for educational purposes and not a substitute for professional medical or psychiatric advice when appropriate.

SCOPE: Mental Health, Psychology, and Psychiatry ONLY''';

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
    if (apiKey.isEmpty) {
      return 'Please add your Gemini API key to the apiKey variable in psychiatrist_service.dart to enable chat functionality.';
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
            'temperature': 0.7,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2250,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
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
