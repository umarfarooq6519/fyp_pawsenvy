import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/models/message.dart';
import 'package:fyp_pawsenvy/core/services/gemini.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiApiService _apiService = GeminiApiService();
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasApiKey => _apiService.hasApiKey;

  ChatProvider() {
    _loadMessages();
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Prepare conversation history for API
      final conversationHistory =
          _messages
              .where((msg) => msg != userMessage) // Exclude the current message
              .map(
                (msg) => {
                  'role': msg.isUser ? 'user' : 'model',
                  'content': msg.content,
                },
              )
              .toList();

      // Get response from Gemini API
      final response = await _apiService.sendMessage(
        content,
        conversationHistory,
      );

      // Add assistant message
      final assistantMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(assistantMessage);
      await _saveMessages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _error = null;
    _saveMessages();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString('chat_messages');
      if (messagesJson != null) {
        final List<dynamic> messagesList = jsonDecode(messagesJson);
        _messages.addAll(
          messagesList.map((json) => Message.fromJson(json)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = jsonEncode(
        _messages.map((message) => message.toJson()).toList(),
      );
      await prefs.setString('chat_messages', messagesJson);
    } catch (e) {
      debugPrint('Error saving messages: $e');
    }
  }
}
