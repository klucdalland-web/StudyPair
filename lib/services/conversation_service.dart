import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/conversation_model.dart';
import 'package:study_pair/models/message_model.dart';
import 'package:study_pair/models/user_model.dart';

class ConversationService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _db.collection('conversations');

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> get _friends =>
      _db.collection('friends');

  CollectionReference<Map<String, dynamic>> _messagesOf(String chatId) =>
      _conversations.doc(chatId).collection('messages');

  Stream<List<ConversationModel>> watchConversations(String userId) {
    if (userId.isEmpty) return const Stream.empty();

    return _db
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ConversationModel.fromDoc).toList());
  }

  Stream<ConversationModel?> watchConversation(String chatId) {
    return _conversations
        .doc(chatId)
        .snapshots()
        .map((doc) => doc.exists ? ConversationModel.fromDoc(doc) : null);
  }

  Future<List<UserModel>> availableContacts(String currentUserId) async {
    final snap = await _users.get();
    return snap.docs
        .where((d) => d.id != currentUserId)
        .map(UserModel.fromDoc)
        .toList();
  }

  Future<ConversationModel> createChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final existing = await _conversations
        .where('participants', arrayContains: currentUserId)
        .get();
    for (final doc in existing.docs) {
      final participants = List<String>.from(
        doc.data()['participants'] as List,
      );
      if (participants.length == 2 && participants.contains(otherUserId)) {
        return ConversationModel.fromDoc(doc);
      }
    }

    final me = await getUser(currentUserId);
    final other = await getUser(otherUserId);

    final ref = _conversations.doc();
    final conversation = ConversationModel(
      id: ref.id,
      participants: [currentUserId, otherUserId],
      participantsInfo: {
        if (me != null)
          currentUserId: ParticipantInfo(
            displayName: me.displayName,
            photoUrl: me.photoUrl,
          ),
        if (other != null)
          otherUserId: ParticipantInfo(
            displayName: other.displayName,
            photoUrl: other.photoUrl,
          ),
      },
    );

    await ref.set(conversation.toMap(isNew: true));
    return conversation;
  }

  Future<ConversationModel> createGroup({
    required String currentUserId,
    required List<String> memberIds,
    required String title,
  }) async {
    final participants = {currentUserId, ...memberIds}.toList();
    final users = await Future.wait(participants.map(getUser));

    final ref = _conversations.doc();
    final conversation = ConversationModel(
      id: ref.id,
      participants: participants,
      title: title,
      participantsInfo: {
        for (final u in users.whereType<UserModel>())
          u.id: ParticipantInfo(
            displayName: u.displayName,
            photoUrl: u.photoUrl,
          ),
      },
    );

    await ref.set(conversation.toMap(isNew: true));
    return conversation;
  }

  Stream<List<MessageModel>> watchMessages(
    String conversationId, {
    int limit = 50,
  }) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map(MessageModel.fromDoc).toList());
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required String content,
  }) async {
    final ref = _messagesOf(conversationId).doc();
    final message = MessageModel(
      id: ref.id,
      conversationId: conversationId,
      content: content,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
    );

    final batch = _db.batch();
    batch.set(ref, message.toMap(isNew: true));
    batch.set(_conversations.doc(conversationId), {
      'lastMessage': content,
      'lastMessageAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await batch.commit();
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromDoc(doc);
  }

  Stream<bool> watchFriendship(String uid1, String uid2) {
    return _friends.where('userIds', arrayContains: uid1).snapshots().map((
      snap,
    ) {
      return snap.docs.any((d) {
        final ids = List<String>.from(d.data()['userIds'] as List);
        return ids.contains(uid2);
      });
    });
  }
}
