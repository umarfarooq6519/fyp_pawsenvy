import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApiService {
  // Replace with your actual API key
  static const String _apiKey = 'AIzaSyBiY-UuzICNmu8ds_ceEcY1t3beDV2QW-0';
  late final GenerativeModel _model;

  GeminiApiService() {
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
  }

  bool get hasApiKey =>
      _apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY_HERE';
  Future<String> sendMessage(
    String message,
    List<Map<String, String>> conversationHistory,
  ) async {
    if (!hasApiKey) {
      throw Exception(
        'API key not set. Please set your Gemini API key in the service.',
      );
    }

    try {
      // Create chat session with history
      final chat = _model.startChat(
        history:
            conversationHistory.map((msg) {
              return Content.text(msg['content']!);
            }).toList(),
      );

      // Send the message
      final response = await chat.sendMessage(Content.text(message));

      return response.text ?? 'No response received';
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
