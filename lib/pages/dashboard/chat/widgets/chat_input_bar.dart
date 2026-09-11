
import 'package:flutter/material.dart';

/// Barre de saisie en bas de la conversation.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: isEnabled,
                decoration: const InputDecoration(
                  hintText: 'Message...',
                ),
                onSubmitted: (_) {
                  if (isEnabled) {
                    onSend();
                  }
                },
              ),
            ),
            IconButton(
              onPressed: isEnabled ? onSend : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

