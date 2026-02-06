import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class WellnessCoachService {
  static const String apiKey =
      'AIzaSyBij1DXaorjs8jJsa0X6Bra2CRO19w5iLI'; // ← Replace with your actual API key!
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // 🔥 SYSTEM PROMPT - WELLNESS COACH
  static const String systemPrompt =
      '''You are an expert Wellness Coach assistant.
You ONLY answer questions related to health, fitness, nutrition, and overall well-being.

RULES:
1. Answer questions about exercise routines, healthy eating, weight management, and stress reduction 🏃‍♂️
2. Provide insights on physical health, mental wellness, sleep hygiene, and lifestyle habits 🍎
3. Explain wellness concepts like mindfulness, hydration, and balanced living 🧘
4. If someone asks about coding, programming, finance, or unrelated topics -> RESPOND: "I am specialized in wellness and health coaching. Please ask me about fitness, nutrition, or personal well-being."
5. Be encouraging, supportive, and concise (2-3 sentences max)
6. Use emojis for clarity
7. Disclaimer: Always mention that this is for educational purposes and not a substitute for professional medical advice when appropriate.

SCOPE: Health, Fitness, Nutrition, and Overall Well-Being ONLY''';

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
