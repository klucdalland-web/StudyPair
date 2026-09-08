import 'package:flutter/material.dart';

import '../../../../models/chat_model.dart';

/// Ligne d'une conversation dans la liste des chats.
class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.title,
    required this.onTap,
  });

  final ChatModel chat;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(chat.lastMessage ?? 'Nouveau chat'),
      onTap: onTap,
    );
  }
}
