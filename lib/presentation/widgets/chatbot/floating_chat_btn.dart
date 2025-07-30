import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/presentation/widgets/chatbot/chat_popup.dart';
import 'package:fyp_pawsenvy/providers/chat.provider.dart';
import 'package:provider/provider.dart';

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key});

  void _openChatPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ChatPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final hasUnreadMessages = chatProvider.messages.isNotEmpty;

        return FloatingActionButton(
          onPressed: () => _openChatPopup(context),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          child: Stack(
            children: [
              const Icon(Icons.chat, size: 28),
              if (hasUnreadMessages)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      chatProvider.messages.length > 99
                          ? '99+'
                          : chatProvider.messages.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
