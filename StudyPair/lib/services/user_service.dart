import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import 'auth_service.dart';

class UserService extends GetxService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<UserModel> getMe() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Non connecté');
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception('Profil introuvable');
    return UserModel.fromDoc(doc);
  }

  Future<void> updateMe(UserModel user) async {
    await _db.collection('users').doc(user.id).set(
      user.toMap(),
      SetOptions(merge: true),
    );
    await _auth.currentUser?.updateDisplayName(user.displayName);
    Get.find<AuthService>().user.value = user;
  }

  Future<List<UserModel>> searchPartners({
    String? subject,
    String? university,
    String? level,
  }) async {
    Query<Map<String, dynamic>> query = _db.collection('users');
    if (university != null && university.isNotEmpty) {
      query = query.where('university', isEqualTo: university);
    }
    if (level != null && level.isNotEmpty) {
      query = query.where('level', isEqualTo: level);
    }
    if (subject != null && subject.isNotEmpty) {
      query = query.where('subjects', arrayContains: subject);
    }
    final snap = await query.limit(50).get();
    final myId = _auth.currentUser?.uid;
    return snap.docs
        .map(UserModel.fromDoc)
        .where((u) => u.id != myId)
        .toList();
  }
}
