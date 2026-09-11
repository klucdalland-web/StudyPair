import 'dart:async';

import 'package:get/get.dart';

import '../../../../models/chat_model.dart';
import '../../../../models/message_model.dart';
import '../../../../models/user_model.dart';

class MockChatService extends GetxService {
  final List<UserModel> _users = [
    UserModel(
      id: 'user1',
      displayName: 'Alex Ouedraogo',
      level: 'Licence en Systèmes d’Information et Réseaux',
      email: 'alex.exa@example.com',
    ),
    UserModel(
      id: 'user2',
      displayName: 'Amadou',
      level: 'Master IA',
      email: 'amadou@example.com',
    ),
    UserModel(
      id: 'user3',
      displayName: 'Fatou Ndjai',
      level: 'Ingénieur DevOps ',
      email: 'fatou@example.com',
    ),
  ];

  final List<ChatModel> _chats = [
    ChatModel(
      id: 'chat1',
      participantIds: const ['user1', 'user2'],
      isValidated: true,
      lastMessage: "Ok, je pense que je peux t'aider pour ton projet Web.",
      lastMessageAt: DateTime.now(),
    ),
    const ChatModel(
      id: 'chat2',
      participantIds: ['user3', 'user1'],
      isValidated: true,
    ),
    const ChatModel(
      id: 'chat3',
      participantIds: ['user2', 'user1'],
      isValidated: false,
    ),
  ];

  final List<MessageModel> _messages = [
    MessageModel(
      id: '1',
      chatId: 'chat1',
      senderId: 'user1',
      content: 'Bonjour, tu vas  bien ?',
      sendAt: DateTime.now(),
      isRead: true,
    ),
    MessageModel(
      id: '2',
      chatId: 'chat1',
      senderId: 'user2',
      content: 'Ça va bien et chez toi ?',
      sendAt: DateTime.now(),
      isRead: true,
    ),
    MessageModel(
      id: '3',
      chatId: 'chat1',
      senderId: 'user1',
      content: "Ça va aussi, j'ai besoin d'aide pour mon projet.",
      sendAt: DateTime.now(),
      isRead: true,
    ),
    MessageModel(
      id: '4',
      chatId: 'chat1',
      senderId: 'user2',
      content: "Tu peux m'en dire plus sur ton projet ?",
      sendAt: DateTime.now(),
      isRead: true,
    ),
    MessageModel(
      id: '5',
      chatId: 'chat1',
      senderId: 'user1',
      content: "Oui, c'est un projet de web development.",
      sendAt: DateTime.now(),
      isRead: true,
    ),
    MessageModel(
      id: '6',
      chatId: 'chat1',
      senderId: 'user2',
      content: "Ok, je pense que je peux t'aider pour ton projet Web.",
      sendAt: DateTime.now(),
      isRead: true,
    ),
  ];

  final _messageController = StreamController<List<MessageModel>>.broadcast();

  Stream<List<ChatModel>> watchChats() {
    return Stream.value(List.unmodifiable(_chats));
  }

  Stream<List<MessageModel>> watchMessages(String chatId) {
    Future.microtask(() {
      _messageController.add(
        _messages.where((message) => message.chatId == chatId).toList(),
      );
    });

    return _messageController.stream;
  }

  Future<void> sendMessage(
    String chatId,
    String content,
    DateTime sendAt,
  ) async {
    if (!canSendMessage(chatId)) {
      throw Exception('Limite de messages atteinte. Validez la conversation.');
    }

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: 'user1',
      content: content,
      sendAt: sendAt,
      isRead: false,
    );
    _messages.add(message);

    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chats[index] = _chats[index].copyWith(
        lastMessage: content,
        lastMessageAt: sendAt,
      );
    }

    _messageController.add(
      _messages.where((message) => message.chatId == chatId).toList(),
    );
  }

  bool canSendMessage(String chatId) {
    final chat = _chats.firstWhere((chat) => chat.id == chatId);

    if (chat.isValidated) return true;

    final messageCount =
        _messages.where((message) => message.chatId == chatId).length;

    return messageCount < 6;
  }

  Future<ChatModel> validateChat(String chatId) async {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) throw Exception('Conversation introuvable');

    _chats[index] = _chats[index].copyWith(isValidated: true);
    return _chats[index];
  }

  UserModel getUserById(String userId) {
    return _users.firstWhere((user) => user.id == userId);
  }

  @override
  void onClose() {
    _messageController.close();
    super.onClose();
  }
}
