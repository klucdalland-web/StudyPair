import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/dashboard/chats/services/mock_chat_service.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class ChatController extends GetxController {
  final MockChatService _chats = Get.find<MockChatService>();
  final AuthService _auth = Get.find<AuthService>();
  final TextEditingController inputController = TextEditingController();

  // ─────────── État ───────────
  final Rxn<ChatModel> chat = Rxn<ChatModel>();
  final Rxn<UserModel> otherUser = Rxn<UserModel>();
  final RxnString error = RxnString();
  final RxBool isValidated = false.obs;

  Stream<List<MessageModel>>? _messagesStream;
  Stream<List<MessageModel>>? get messagesStream => _messagesStream;

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
  }

  // ─────────── Initialisation ───────────
  void _initFromArguments() {
    final args = Get.arguments;
    final chatId = Get.parameters['chatId'];

    if (args is ChatModel) {
      chat.value = args;
      isValidated.value = args.isValidated;

      final otherId = args.participantIds.firstWhere(
        (id) => id != _auth.uid,
        orElse: () => '',
      );

      if (otherId.isNotEmpty) {
        otherUser.value = _chats.getUserById(otherId);
      }

      _messagesStream = _chats.watchMessages(args.id);
    } else if (chatId != null && chatId.isNotEmpty) {
      chat.value = ChatModel(
        id: chatId,
        participantIds: const [],
        isValidated: false,
      );
      _messagesStream = _chats.watchMessages(chatId);
    } else {
      error.value = 'Conversation introuvable';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.dashboard);
      });
    }
  }

  // ─────────── Actions ───────────
  bool isMine(MessageModel m) => m.senderId == _auth.uid;

  Future<void> send() async {
    final c = chat.value;
    if (c == null) return;

    final text = inputController.text.trim();
    if (text.isEmpty) return;

    try {
      await _chats.sendMessage(c.id, text, DateTime.now());
      inputController.clear();
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<void> validate() async {
    final c = chat.value;
    if (c == null || isValidated.value) return;

    await _chats.validateChat(c.id);
    isValidated.value = true;
  }

  void goBack() => Get.back<void>();

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
