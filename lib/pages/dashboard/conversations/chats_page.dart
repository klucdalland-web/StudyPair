import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/conversation_controller.dart';
import 'package:study_pair/models/conversation_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/conversations/widgets/chat_tile.dart';
import 'package:study_pair/routes/app_routes.dart';
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

  ConversationsController get _ctrl => Get.find<ConversationsController>();

  String get _currentUserId => _ctrl.currentUserId;

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
          onTap: _createConversation,
        ),
        AppSheetAction(
          label: 'Groupe',
          icon: Icons.groups_rounded,
          onTap: _createGroup,
        ),
      ],
    );
  }

  Future<void> _createConversation() async {
    final contacts = await _ctrl.availableContacts();
    if (contacts.isEmpty) {
      Get.snackbar('Info', 'Aucun contact disponible pour le moment.');
      return;
    }

    final selected = await _pickConversationContact(
      context: context,
      contacts: contacts,
    );
    if (selected == null || !mounted) return;

    try {
      final chat = await _ctrl.createChat(selected.id);
      await Get.toNamed(Routes.chatPath(chat.id), arguments: chat);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<UserModel?> _pickConversationContact({
    required BuildContext context,
    required List<UserModel> contacts,
  }) {
    return showModalBottomSheet<UserModel>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) => SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];

            return Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person_outline_rounded),
                ),
                title: Text(contact.displayName),
                subtitle: contact.email.isEmpty ? null : Text(contact.email),
                onTap: () => Navigator.of(context).pop(contact),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _createGroup() async {
    final contacts = await _ctrl.availableContacts();
    if (contacts.length < 2) {
      Get.snackbar('Info', 'Il faut au moins 2 contacts pour créer un groupe.');
      return;
    }

    final result = await _pickGroupMembers(
      context: context,
      contacts: contacts,
    );
    if (result == null || !mounted) return;

    try {
      final chat = await _ctrl.createGroup(
        memberIds: result.members.map((u) => u.id).toList(),
        title: result.title,
      );
      await Get.toNamed(Routes.chatPath(chat.id), arguments: chat);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<_GroupMembersResult?> _pickGroupMembers({
    required BuildContext context,
    required List<UserModel> contacts,
  }) {
    final selectedIds = <String>{};
    final titleController = TextEditingController();

    return showModalBottomSheet<_GroupMembersResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Nom du groupe'),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (_, index) {
                      final contact = contacts[index];
                      return CheckboxListTile(
                        value: selectedIds.contains(contact.id),
                        title: Text(contact.displayName),
                        onChanged: (checked) => setState(() {
                          if (checked == true) {
                            selectedIds.add(contact.id);
                          } else {
                            selectedIds.remove(contact.id);
                          }
                        }),
                      );
                    },
                  ),
                ),
                AppButton(
                  label: 'Créer le groupe',
                  onPressed: selectedIds.length < 2
                      ? null
                      : () => Navigator.of(sheetContext).pop(
                          _GroupMembersResult(
                            members: contacts
                                .where(
                                  (contact) => selectedIds.contains(contact.id),
                                )
                                .toList(),
                            title: titleController.text.trim(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(titleController.dispose);
  }

  String _chatTitle(ConversationModel c) {
    if (c.isGroup) {
      return (c.title?.trim().isNotEmpty ?? false)
          ? c.title!
          : 'Groupe (${c.participants.length})';
    }
    return c.otherParticipantInfo(_currentUserId)?.displayName ?? 'Utilisateur';
  }

  // Dans _ChatsPageState de chats_page.dart

  UserModel _tileUser(ConversationModel c) {
    final lastMessage = (c.lastMessage?.trim().isNotEmpty ?? false)
        ? c.lastMessage!.trim()
        : 'Nouvelle conversation';

    if (c.isGroup) {
      return UserModel(
        id: c.id,
        email: '',
        displayName: _chatTitle(c),
        level: lastMessage,
      );
    }

    final otherId = c.participants.firstWhere(
      (id) => id != _currentUserId,
      orElse: () => '',
    );
    final info = c.participantsInfo[otherId];
    return UserModel(
      id: otherId,
      email: '',
      displayName: info?.displayName ?? 'Utilisateur',
      level: lastMessage,
      photoUrl: info?.photoUrl,
    );
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
                    onChanged: _ctrl.updateQuery,
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
          Obx(() {
            if (_ctrl.isLoading.value) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: LoadingView(message: 'Chargement des messages…'),
              );
            }

            final q = _ctrl.query.value;
            final list = _ctrl.conversations.where((c) {
              if (q.isEmpty) return true;
              final haystack = [
                _chatTitle(c),
                c.lastMessage ?? '',
              ].join(' ').toLowerCase();
              return haystack.contains(q);
            }).toList();

            if (list.isEmpty) {
              return SoftEmpty(onCreate: _onCreatePressed);
            }

            return SoftList(conversations: list, tileUser: _tileUser);
          }),
        ],
      ),
    );
  }
}

class _GroupMembersResult {
  const _GroupMembersResult({required this.members, required this.title});

  final List<UserModel> members;
  final String title;
}

class SoftEmpty extends StatelessWidget {
  const SoftEmpty({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyView(
        message: 'Aucune conversation.\nCrée un échange privé ou un groupe.',
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
    required this.conversations,
    required this.tileUser,
  });

  final List<ConversationModel> conversations;
  final UserModel Function(ConversationModel c) tileUser;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
      sliver: SliverList.separated(
        itemCount: conversations.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          indent: 76,
          endIndent: 12,
          color: AppColors.divider,
        ),
        itemBuilder: (_, i) {
          final conversation = conversations[i];
          return ChatTile(
            conversation: conversation,
            user: tileUser(conversation),
            onTap: () => Get.toNamed(
              Routes.chatPath(conversation.id),
              arguments: conversation,
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
