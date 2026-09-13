import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/conversation_model.dart';
import 'package:study_pair/models/message_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/services/conversation_service.dart';
import 'package:study_pair/services/demande_service.dart';

class ChatController extends GetxController {
  ChatController({ConversationService? service})
    : _service = service ?? Get.find<ConversationService>();

  final ConversationService _service;

  AuthService get _auth => Get.find<AuthService>();

  String get currentUserId => _auth.uid ?? '';

  late final String chatId;

  final Rx<ConversationModel?> chat = Rx<ConversationModel?>(null);
  final Rxn<String> error = Rxn<String>();
  final Rxn<UserModel> otherUser = Rxn<UserModel>();
  final RxBool isValidated = false.obs;

  final TextEditingController inputController = TextEditingController();

  StreamSubscription<ConversationModel?>? _chatSub;
  StreamSubscription<bool>? _friendshipSub;

  String? _otherUserId;
  UserModel? _me;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    String? id;
    if (args is String) {
      id = args;
    } else if (args is ConversationModel) {
      id = args.id;
      chat.value = args;
    } else {
      id = Get.parameters['id'];
    }

    if (id == null || id.isEmpty) {
      error.value = 'Conversation introuvable.';
      return;
    }

    chatId = id;
    _listenChat();
    _loadMe();
  }

  @override
  void onClose() {
    _chatSub?.cancel();
    _friendshipSub?.cancel();
    inputController.dispose();
    super.onClose();
  }

  void _listenChat() {
    _chatSub = _service.watchConversation(chatId).listen((c) {
      chat.value = c;
      if (c == null) return;

      final otherId = c.otherParticipant(currentUserId);
      if (_otherUserId != otherId) {
        _otherUserId = otherId;
        _loadOtherUser(otherId);
        _watchFriendship(otherId);
      }
    }, onError: (_) => error.value = 'Erreur de chargement.');
  }

  Future<void> _loadMe() async {
    _me = await _service.getUser(currentUserId);
  }

  Future<void> _loadOtherUser(String otherId) async {
    otherUser.value = await _service.getUser(otherId);
  }

  void _watchFriendship(String otherId) {
    _friendshipSub?.cancel();
    _friendshipSub = _service
        .watchFriendship(currentUserId, otherId)
        .listen((areFriends) => isValidated.value = areFriends);
  }

  Stream<List<MessageModel>> get messagesStream =>
      _service.watchMessages(chatId);

  bool isMine(MessageModel m) => m.senderId == currentUserId;

  Future<void> send() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    _me ??= await _service.getUser(currentUserId);

    inputController.clear();
    await _service.sendMessage(
      conversationId: chatId,
      senderId: currentUserId,
      senderName: _me?.displayName ?? '',
      senderPhotoUrl: _me?.photoUrl,
      content: text,
    );
  }

  Future<void> validate() async {
    if (_otherUserId == null) return;
    await Get.find<DemandeService>().create(
      receiverId: _otherUserId!,
      subject: 'Étudier ensemble',
      message: 'Salut, on continue en tant que study buddies ?',
    );
  }

  void goBack() => Get.back();
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationService>(() => ConversationService());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
