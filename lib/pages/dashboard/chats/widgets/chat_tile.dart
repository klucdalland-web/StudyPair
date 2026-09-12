import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_text.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/user_model.dart';

/// Ligne d'une conversation dans la liste des chats.
class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat, required this.user});

  final ChatModel chat;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      leading: CircleAvatar(
        radius: 28,
        child: AppText(
          user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      title: AppText(
        user.displayName,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),

      subtitle: AppText(
        user.level ?? 'Impossible de récupérer le niveau',
        fontSize: 14,
        color: const Color(0xFF6B7280),
      ),

      trailing: const Icon(Icons.chevron_right, size: 28),
    );
  }
}
