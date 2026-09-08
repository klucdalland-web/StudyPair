import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/chat_service.dart';
import 'widgets/chat_tile.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = Get.find<ChatService>();
    final auth = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Conversations')),
      body: StreamBuilder<List<ChatModel>>(
        stream: chats.watchChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Aucune conversation'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final chat = list[i];
              final other = chat.participantIds.firstWhere(
                (id) => id != auth.uid,
                orElse: () => 'Chat',
              );
              return ChatTile(
                chat: chat,
                title: other,
                onTap: () => Get.toNamed(
                  Routes.chatPath(chat.id),
                  arguments: chat,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
