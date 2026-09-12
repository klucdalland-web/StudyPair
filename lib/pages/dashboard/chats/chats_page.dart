import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/widgets/app_header.dart';

import '../../../models/chat_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../chats/services/mock_chat_service.dart';
import 'widgets/chat_tile.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  static const _bg = Color(0xFFF5F6F8);
  static const _surface = Colors.white;
  static const _primary = Color(0xFF3A6EA5);
  static const _textPrimary = Color(0xFF1F2937);
  static const _textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final chats = Get.find<MockChatService>();
    final auth = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppHeader(
              label: 'Conversations',
              showAvatar: false,
              onNotificationsTap: () {},
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: _SearchBar(),
            ),

            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: StreamBuilder<List<ChatModel>>(
                  stream: chats.watchChats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: _primary),
                      );
                    }

                    final list = snapshot.data ?? [];

                    if (list.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 84,
                        endIndent: 16,
                        color: Color(0xFFEEF0F3),
                      ),
                      itemBuilder: (_, i) {
                        final chat = list[i];

                        final otherId = chat.participantIds.firstWhere(
                          (id) => id != auth.uid,
                          orElse: () => 'Chat',
                        );

                        final otherUser = chats.getUserById(otherId);

                        return InkWell(
                          onTap: () => Get.toNamed(
                            Routes.chatPath(chat.id),
                            arguments: chat,
                          ),
                          child: ChatTile(chat: chat, user: otherUser),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: ChatsPage._surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search_rounded, size: 20, color: ChatsPage._textSecondary),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Rechercher une conversation…',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: ChatsPage._textSecondary,
                ),
              ),
              style: TextStyle(fontSize: 14, color: ChatsPage._textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: ChatsPage._primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 44,
                color: ChatsPage._primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucune conversation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ChatsPage._textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Démarrez un échange avec un binôme ou un tuteur\npour le voir apparaître ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: ChatsPage._textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
