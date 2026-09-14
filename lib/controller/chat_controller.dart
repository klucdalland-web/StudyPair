import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/conversation_model.dart';
import 'package:study_pair/models/message_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/services/conversation_service.dart';
import 'package:study_pair/services/demande_service.dart';

enum MessageStatus { sent, delivered, read }

extension MessageStatusX on MessageStatus {
  IconData get icon => switch (this) {
    MessageStatus.sent => Icons.check_rounded,
    MessageStatus.delivered => Icons.done_all_rounded,
    MessageStatus.read => Icons.done_all_rounded,
  };
  Color get color => switch (this) {
    MessageStatus.sent => Colors.grey,
    MessageStatus.delivered => Colors.grey.shade600,
    MessageStatus.read => Colors.blue,
  };
}

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
  bool get isGroup => chat.value?.isGroup ?? false;
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

    // marque comme lu dès l'ouverture
    _service.markAsRead(chatId, currentUserId);
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

  Stream<List<MessageModel>> get messagesStream =>
      _service.watchMessages(chatId).map((list) {
        if (list.isNotEmpty && list.first.createdAt != _lastSeen) {
          _lastSeen = list.first.createdAt;
          _service.markAsRead(chatId, currentUserId);
        }
        return list;
      });

  DateTime? _lastSeen;

  /// Renvoie le statut d'un message que J'AI envoyé.
  MessageStatus statusFor(MessageModel m) {
    final c = chat.value;
    if (c == null || m.createdAt == null) return MessageStatus.sent;

    final others = c.participants.where((id) => id != currentUserId).toList();
    if (others.isEmpty) return MessageStatus.sent;

    final allRead = others.every((uid) {
      final t = c.lastReadAt?[uid];
      return t != null && !t.isBefore(m.createdAt!);
    });
    return allRead ? MessageStatus.read : MessageStatus.sent;
  }

  int readCountFor(MessageModel m) {
    final c = chat.value;
    if (c == null || m.createdAt == null) return 0;
    return c.participants.where((id) {
      if (id == currentUserId) return false;
      final t = c.lastReadAt?[id];
      return t != null && !t.isBefore(m.createdAt!);
    }).length;
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
