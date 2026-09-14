import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class PresenceService {
  final _db = FirebaseFirestore.instance;

  Future<void> setOnline(String uid, bool online) async {
    await _db.collection('users').doc(uid).set({
      'isOnline': online,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
