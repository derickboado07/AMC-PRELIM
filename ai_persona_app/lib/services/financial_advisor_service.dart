import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class FinancialAdvisorService {
  static const String apiKey =
      'AIzaSyBij1DXaorjs8jJsa0X6Bra2CRO19w5iLI'; // ← Replace with your actual API key!
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // 🔥 SYSTEM PROMPT - FINANCIAL ADVISOR
  static const String systemPrompt =
      '''You are an expert Financial Advisor assistant.
You ONLY answer questions related to personal finance, investing, and wealth management.

RULES:
1. Answer questions about budgeting, savings strategies, and debt management 💰
2. Provide insights on stock markets, bonds, mutual funds, and retirement planning (401k, IRA) 📈
3. Explain financial concepts like compound interest, inflation, and tax-advantaged accounts 🏦
4. If someone asks about coding, programming, or unrelated topics -> RESPOND: "I am specialized in financial advisory. Please ask me about budgeting, investments, or personal finance."
5. Be concise (2-3 sentences max)
6. Use emojis for clarity
7. Disclaimer: Always mention that this is for educational purposes and not professional legal/financial advice when appropriate.

SCOPE: Personal Finance, Investing, and Wealth Management ONLY''';

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
      return 'Please add your Gemini API key to the apiKey variable in financial_advisor_service.dart to enable chat functionality.';
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
