import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService extends GetxService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Non connecté');
    return uid;
  }

  Stream<List<ChatModel>> watchChats() {
    return _db
        .collection('chats')
        .where('participantIds', arrayContains: _uid)
        .snapshots()
        .map((s) => s.docs.map(ChatModel.fromDoc).toList());
  }

  Stream<List<MessageModel>> watchMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => MessageModel.fromDoc(d, chatId: chatId))
              .toList(),
        );
  }

  Future<void> sendMessage(String chatId, String content) async {
    final ref = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();
    final message = MessageModel(
      id: ref.id,
      chatId: chatId,
      senderId: _uid,
      content: content.trim(),
    );
    final batch = _db.batch();
    batch.set(ref, message.toMap());
    batch.update(_db.collection('chats').doc(chatId), {
      'lastMessage': message.content,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }
}
