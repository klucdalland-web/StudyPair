import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/chat_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/chats/services/mock_chat_service.dart';
import 'package:study_pair/pages/dashboard/chats/widgets/chat_tile.dart';
import 'package:study_pair/routes/app_routes.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_header.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/app_scaffold.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/app_text_field.dart';
import 'package:study_pair/widgets/empty_view.dart';
import 'package:study_pair/widgets/gap.dart';
import 'package:study_pair/widgets/loading_view.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _search = TextEditingController();
  String _query = '';

  MockChatService get _chats => Get.find<MockChatService>();
  AuthService get _auth => Get.find<AuthService>();

  /// Mock actuel : les conversations tournent autour de `user1`.
  String get _currentUserId => _auth.uid ?? 'user1';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _createConversation() async {
    final contacts = _chats.availableContacts(_currentUserId);
    if (contacts.isEmpty) {
      Get.snackbar('Info', 'Aucun contact disponible pour le moment.');
      return;
    }

    final selected = await showAppBottomSheet<UserModel>(
      context: context,
      title: 'Nouvelle conversation',
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.45,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: contacts.length,
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            color: AppColors.divider,
          ),
          itemBuilder: (_, i) {
            final user = contacts[i];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppAvatar(
                imageUrl: user.photoUrl,
                name: user.displayName,
                size: 44,
                online: user.isOnline,
              ),
              title: AppText(
                user.displayName,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              subtitle: AppText(
                user.level ?? user.email,
                fontSize: 12,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.of(context).pop(user),
            );
          },
        ),
      ),
    );

    if (selected == null || !mounted) return;

    final chat = await _chats.createChat(
      currentUserId: _currentUserId,
      otherUserId: selected.id,
    );

    await Get.toNamed(Routes.chatPath(chat.id), arguments: chat);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.white,
      safeTop: false,
      safeBottom: false,
      body: CustomScrollView(
        physics: AppPlatform.scrollPhysics,
        slivers: [
          const SliverChatsHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  AppSearchField(
                    controller: _search,
                    hint: 'Rechercher une conversation…',
                    onChanged: (q) =>
                        setState(() => _query = q.trim().toLowerCase()),
                  ),
                  const VGap.md(),
                  AppButton(
                    label: 'Créer une conversation',
                    icon: Icons.add_comment_rounded,
                    onPressed: _createConversation,
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<List<ChatModel>>(
            stream: _chats.watchChats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingView(message: 'Chargement des messages…'),
                );
              }

              final list = (snapshot.data ?? []).where((chat) {
                if (_query.isEmpty) return true;
                final otherId = chat.participantIds.firstWhere(
                  (id) => id != _currentUserId,
                  orElse: () => '',
                );
                final user = _chats.getUserById(otherId);
                final haystack = [
                  user.displayName,
                  user.level ?? '',
                  chat.lastMessage ?? '',
                ].join(' ').toLowerCase();
                return haystack.contains(_query);
              }).toList();

              if (list.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyView(
                    message:
                        'Aucune conversation.\nDémarrez un échange avec un binôme ou un tuteur.',
                    icon: Icons.chat_bubble_outline_rounded,
                    actionLabel: 'Créer une conversation',
                    onAction: _createConversation,
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
                sliver: SliverList.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    indent: 76,
                    endIndent: 12,
                    color: AppColors.divider,
                  ),
                  itemBuilder: (_, i) {
                    final chat = list[i];
                    final otherId = chat.participantIds.firstWhere(
                      (id) => id != _currentUserId,
                      orElse: () => '',
                    );
                    final otherUser = _chats.getUserById(otherId);

                    return ChatTile(
                      chat: chat,
                      user: otherUser,
                      onTap: () => Get.toNamed(
                        Routes.chatPath(chat.id),
                        arguments: chat,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SliverChatsHeader extends StatelessWidget {
  const SliverChatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPersistentHeader(
      pinned: true,
      delegate: AppHeaderDelegate(
        heroTag: 'chats-header',
        title: 'StudyPair',
        subtitle: 'Messages',
        showBackButton: false,
      ),
    );
  }
}
