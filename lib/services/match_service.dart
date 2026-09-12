import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/demande_model.dart';
import 'package:study_pair/services/demande_service.dart';

class MatchService extends GetxService {
  final _auth = FirebaseAuth.instance;

  Future<DemandeModel> requestMatch({
    required String partnerId,
    required String subject,
    String message = '',
    DemandeHelpType helpType = DemandeHelpType.binome,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Non connecté');

    return Get.find<DemandeService>().create(
      receiverId: partnerId,
      subject: subject,
      message: message.trim().isEmpty
          ? 'Salut ! Je voudrais travailler avec toi sur $subject.'
          : message.trim(),
      helpType: helpType,
    );
  }
}
