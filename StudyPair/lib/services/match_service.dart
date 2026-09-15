import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/match_model.dart';

class MatchService extends GetxService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> requestMatch({
    required String partnerId,
    required String subject,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Non connecté');
    final ref = _db.collection('matches').doc();
    await ref.set(
      MatchModel(
        id: ref.id,
        requesterId: uid,
        partnerId: partnerId,
        subject: subject,
      ).toMap(),
    );
  }
}
