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
          ? " Bonjour, je serais ravi(e) de vous ajouter à mon réseau professionnel"
          : message.trim(),
      helpType: helpType,
    );
  }

  Future<String> relationAvec(String partnerId) {
    return Get.find<DemandeService>().relationAvec(partnerId);
  }
}