import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_card.dart';
import '../chats/services/mock_chat_service.dart';
import 'widgets/chat_tile.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = Get.find<MockChatService>();
    final auth = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: chats.watchChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return const Center(
              child: Text('Aucune conversation'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final chat = list[i];

              final otherId = chat.participantIds.firstWhere(
                (id) => id != auth.uid,
                orElse: () => 'Chat',
              );

              final otherUser = chats.getUserById(otherId);

              return AppCard(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                padding: EdgeInsets.zero,
                onTap: () => Get.toNamed(
                  Routes.chatPath(chat.id),
                  arguments: chat,
                ),
                child: ChatTile(
                  chat: chat,
                  user: otherUser,
                ),
              );
            },
          );
        },
      ),
    );
  }
}