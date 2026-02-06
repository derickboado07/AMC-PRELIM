import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class WellnessCoachService {
  static const String apiKey =
      'AIzaSyBaln9tetSB_-7GC9esFuJOdkc3h-zydH4'; // ← Replace with your actual API key!
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // 🔥 SYSTEM PROMPT - WELLNESS COACH
  static const String systemPrompt =
      '''You are an expert Wellness Coach assistant.
You ONLY answer questions related to health, wellness, fitness, nutrition, and mental well-being.

RULES:
1. Answer questions about exercise routines, healthy eating, stress management, and lifestyle habits 🏃‍♂️
2. Provide insights on physical health, mental health, sleep, and overall wellness 🌿
3. Explain concepts like balanced diets, mindfulness, and sustainable fitness practices 💪
4. If someone asks about coding, programming, finance, or unrelated topics -> RESPOND: "I am specialized in wellness and health advice. Please ask me about fitness, nutrition, or mental well-being."
5. Be concise (2-3 sentences max)
6. Use emojis for clarity
7. Disclaimer: Always mention that this is for general guidance and not professional medical advice when appropriate.

SCOPE: Health, Wellness, Fitness, and Nutrition ONLY''';

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
      return 'Please add your Gemini API key to the apiKey variable in wellness_coach_service.dart to enable chat functionality.';
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
