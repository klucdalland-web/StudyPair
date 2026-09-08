import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/chat_service.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chats = Get.find<ChatService>();
  final _auth = Get.find<AuthService>();
  final _input = TextEditingController();

  ChatModel? _chat;
  String? _error;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    final chatId = Get.parameters['chatId'];

    if (args is ChatModel) {
      _chat = args;
    } else if (chatId != null && chatId.isNotEmpty) {
      _chat = ChatModel(id: chatId, participantIds: const []);
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
      await _chats.sendMessage(chat.id, text);
      _input.clear();
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
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
        appBar: AppBar(title: const Text('Discussion')),
        body: Center(child: Text(_error ?? 'Chargement...')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Discussion')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chats.watchMessages(chat.id),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final m = messages[i];
                    return MessageBubble(
                      content: m.content,
                      mine: m.senderId == _auth.uid,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputBar(controller: _input, onSend: _send),
        ],
      ),
    );
  }
}
