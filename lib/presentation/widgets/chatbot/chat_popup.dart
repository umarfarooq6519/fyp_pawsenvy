import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/providers/chat.provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'message_bubble.dart';
import 'message_input.dart';

class ChatPopup extends StatefulWidget {
  const ChatPopup({super.key});

  @override
  State<ChatPopup> createState() => _ChatPopupState();
}

class _ChatPopupState extends State<ChatPopup> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            context.read<ChatProvider>().clearError();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.1,
      ),
      child: Container(
        width: screenSize.width * 0.9,
        height: screenSize.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(LineIcons.robot, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Pet Assistant',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      if (chatProvider.messages.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColorStyles.black,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Clear Chat'),
                                  content: const Text(
                                    'Are you sure you want to clear all messages?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        chatProvider.clearMessages();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Clear'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColorStyles.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Chat content
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  // Show error if exists
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (chatProvider.error != null) {
                      _showError(chatProvider.error!);
                      chatProvider.clearError();
                    }

                    // Auto-scroll to bottom when new messages arrive
                    if (chatProvider.messages.isNotEmpty) {
                      _scrollToBottom();
                    }
                  });

                  return chatProvider.messages.isEmpty
                      ? _buildEmptyState(theme, chatProvider.hasApiKey)
                      : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(
                            message: chatProvider.messages[index],
                          );
                        },
                      );
                },
              ),
            ),
            // Message input
            Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return MessageInput(
                  onSendMessage: chatProvider.sendMessage,
                  isLoading: chatProvider.isLoading,
                  isEnabled: chatProvider.hasApiKey,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool hasApiKey) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          hasApiKey
              ? 'Start a conversation by typing a message below.'
              : 'Please configure your Gemini API key in the service.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
