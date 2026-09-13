import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notification_model.dart';

class NotificationsService {
  NotificationsService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _collection {
    final uid = _uid;
    if (uid == null) {
      throw StateError('Aucun utilisateur connecté.');
    }
    return _firestore.collection('users').doc(uid).collection('notifications');
  }

  Stream<List<NotificationModel>> watchNotifications() {
    if (_uid == null) return const Stream.empty();
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(NotificationModel.fromDoc).toList(),
        );
  }

  Future<void> markAsRead(String notificationId) {
    return _collection.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(List<String> notificationIds) async {
    if (notificationIds.isEmpty) return;
    final batch = _firestore.batch();
    for (final id in notificationIds) {
      batch.update(_collection.doc(id), {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String notificationId) {
    return _collection.doc(notificationId).delete();
  }
}
