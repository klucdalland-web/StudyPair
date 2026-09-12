import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/chat_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/chats/services/mock_chat_service.dart';
import 'package:study_pair/pages/dashboard/chats/widgets/chat_tile.dart';
import 'package:study_pair/pages/dashboard/chats/widgets/create_chat_sheet.dart';
import 'package:study_pair/routes/app_routes.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_header.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/app_scaffold.dart';
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

  String get _currentUserId => _auth.uid ?? 'user1';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _onCreatePressed() async {
    await showAppActionSheet(
      context: context,
      title: 'Que veux-tu créer ?',
      actions: [
        AppSheetAction(
          label: 'Conversation',
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () => _createConversation(),
        ),
        AppSheetAction(
          label: 'Groupe',
          icon: Icons.groups_rounded,
          onTap: () => _createGroup(),
        ),
      ],
    );
  }

  Future<void> _createConversation() async {
    final contacts = _chats.availableContacts(_currentUserId);
    if (contacts.isEmpty) {
      Get.snackbar('Info', 'Aucun contact disponible pour le moment.');
      return;
    }

    final selected = await pickConversationContact(
      context: context,
      contacts: contacts,
    );
    if (selected == null || !mounted) return;

    final chat = await _chats.createChat(
      currentUserId: _currentUserId,
      otherUserId: selected.id,
    );

    await Get.toNamed(Routes.chatPath(chat.id), arguments: chat);
  }

  Future<void> _createGroup() async {
    final contacts = _chats.availableContacts(_currentUserId);
    if (contacts.length < 2) {
      Get.snackbar(
        'Info',
        'Il faut au moins 2 contacts pour créer un groupe.',
      );
      return;
    }

    final result = await pickGroupMembers(
      context: context,
      contacts: contacts,
    );
    if (result == null || !mounted) return;

    try {
      final chat = await _chats.createGroup(
        currentUserId: _currentUserId,
        memberIds: result.members.map((u) => u.id).toList(),
        title: result.title,
      );
      await Get.toNamed(Routes.chatPath(chat.id), arguments: chat);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  String _chatTitle(ChatModel chat) {
    if (chat.isGroup) {
      return chat.title?.trim().isNotEmpty == true
          ? chat.title!
          : 'Groupe (${chat.participantIds.length})';
    }
    final otherId = chat.participantIds.firstWhere(
      (id) => id != _currentUserId,
      orElse: () => '',
    );
    return _chats.getUserById(otherId).displayName;
  }

  UserModel _tileUser(ChatModel chat) {
    if (chat.isGroup) {
      return UserModel(
        id: chat.id,
        email: '',
        displayName: _chatTitle(chat),
        level: '${chat.participantIds.length} membres',
      );
    }
    final otherId = chat.participantIds.firstWhere(
      (id) => id != _currentUserId,
      orElse: () => '',
    );
    return _chats.getUserById(otherId);
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
                    label: 'Nouvelle discussion',
                    icon: Icons.add_comment_rounded,
                    onPressed: _onCreatePressed,
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
                final haystack = [
                  _chatTitle(chat),
                  chat.lastMessage ?? '',
                ].join(' ').toLowerCase();
                return haystack.contains(_query);
              }).toList();

              if (list.isEmpty) {
                return SoftEmpty(
                  onCreate: _onCreatePressed,
                );
              }

              return SoftList(
                chats: list,
                tileUser: _tileUser,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SoftEmpty extends StatelessWidget {
  const SoftEmpty({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyView(
        message:
            'Aucune conversation.\nCrée un échange privé ou un groupe.',
        icon: Icons.chat_bubble_outline_rounded,
        actionLabel: 'Nouvelle discussion',
        onAction: onCreate,
      ),
    );
  }
}

class SoftList extends StatelessWidget {
  const SoftList({
    super.key,
    required this.chats,
    required this.tileUser,
  });

  final List<ChatModel> chats;
  final UserModel Function(ChatModel chat) tileUser;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
      sliver: SliverList.separated(
        itemCount: chats.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          indent: 76,
          endIndent: 12,
          color: AppColors.divider,
        ),
        itemBuilder: (_, i) {
          final chat = chats[i];
          return ChatTile(
            chat: chat,
            user: tileUser(chat),
            isGroup: chat.isGroup,
            onTap: () => Get.toNamed(
              Routes.chatPath(chat.id),
              arguments: chat,
            ),
          );
        },
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
