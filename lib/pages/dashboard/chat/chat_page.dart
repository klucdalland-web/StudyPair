
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import '../chats/services/mock_chat_service.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/messages_limit.dart';
import '../../../widgets/app_validate_chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chats = Get.find<MockChatService>();
  final _auth = Get.find<AuthService>();
  final _input = TextEditingController();

  ChatModel? _chat;
  UserModel? _otherUser;
  String? _error;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    final chatId = Get.parameters['chatId'];

    if (args is ChatModel) {
      _chat = args;

      final otherId = args.participantIds.firstWhere(
        (id) => id != _auth.uid,
      );

      _otherUser = _chats.getUserById(otherId);
    } else if (chatId != null && chatId.isNotEmpty) {
      _chat = ChatModel(
        id: chatId,
        participantIds: const [],
        isValidated: false,
      );
    } else {
      _error = 'Conversation introuvable';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.dashboard);
      });
    }
  }

  Future<void> _send() async {
    final chat = _chat;

    if (chat == null) return;

    final text = _input.text.trim();

    if (text.isEmpty) return;

    try {
      await _chats.sendMessage(
        chat.id,
        text,
        DateTime.now(),
      );

      _input.clear();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = _chat;

    if (chat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            _error ?? 'Chargement...',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),

        title: Row(
          children: [
            if (_otherUser != null)
              AppAvatar(
                imageUrl: _otherUser!.photoUrl,
                name: _otherUser!.displayName,
                online: _otherUser!.isOnline,
                onTap: () {},
              ),

            const SizedBox(width: 8),

            if (_otherUser != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _otherUser!.displayName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _otherUser!.level ?? 'Niveau inconnu',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),

        actions: [
          if (!chat.isValidated)
            AppValidateChat(
              onValidate: () async {
                final updated = await _chats.validateChat(chat.id);
                setState(() => _chat = updated);
              },
            ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chats.watchMessages(chat.id),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (_, i) {
                          final m = messages[i];

                          return MessageBubble(
                            content: m.content,
                            mine: m.senderId == 'user1', sendAt: DateTime.now(),
                            // sendAt: '',
                          );
                        },
                      ),
                    ),

                    if (!chat.isValidated)
                      MessageLimit(
                        messageCount: messages.length,
                      ),

                    ChatInputBar(
                      controller: _input,
                      onSend: _send,
                      isEnabled:
                          chat.isValidated ||
                          messages.length < 6,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

