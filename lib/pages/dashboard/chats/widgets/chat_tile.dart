import 'package:flutter/material.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/user_model.dart';

/// Ligne d'une conversation dans la liste des chats.
class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.user,
  });

  final ChatModel chat;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      leading: CircleAvatar(
        radius: 28,
        child: Text(
          user.displayName.isNotEmpty
              ? user.displayName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      title: Text(
        user.displayName,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Text(
        chat.lastMessage ?? user.level ?? 'Aucun message',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      trailing: const Icon(
        Icons.chevron_right,
        size: 28,
      ),
    );
  }
}