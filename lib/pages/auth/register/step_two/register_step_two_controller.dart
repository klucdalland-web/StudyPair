import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/routes/app_routes.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/services/user_service.dart';

class RegisterStepTwoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthService _auth = Get.find<AuthService>();
  final UserService _users = Get.find<UserService>();

  final isLoading = false.obs;

  final establishmentController = TextEditingController();
  final specialtyController = TextEditingController();
  final subjectController = TextEditingController();
  final expertiseController = TextEditingController();
  final mentorPresentationController = TextEditingController();
  final studentDescriptionController = TextEditingController();
  final presentationController = TextEditingController();

  // --- ÉTUDIANT ---
  final RxString studentLevel = 'L3'.obs;
  final RxList<String> selectedSubjects = <String>[
    'Algorithmique',
    'Python',
    'Maths discrètes',
    'Prépa examens',
  ].obs;
  final RxString studentFrequency = '2h / semaine'.obs;
  final RxString studentMoment = 'Soir en semaine'.obs;

  // --- MENTOR ---
  final RxString mentorLevel = 'Sélectionnez votre niveau'.obs;
  final RxList<String> selectedExpertises = <String>[
    'Intelligence Artificielle',
    'Algorithmes & C++',
  ].obs;
  final RxString mentorCapacity = '2 binômes'.obs;
  final RxString mentorFormat = 'Visio'.obs;

  void updateStudentLevel(String level) => studentLevel.value = level;

  void toggleSubject(String subject) {
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      selectedSubjects.add(subject);
    }
  }

  void updateMentorCapacity(String capacity) => mentorCapacity.value = capacity;
  void updateMentorFormat(String format) => mentorFormat.value = format;

  void toggleExpertise(String expertise) {
    if (selectedExpertises.contains(expertise)) {
      selectedExpertises.remove(expertise);
    } else {
      selectedExpertises.add(expertise);
    }
  }

  bool validateStudentExtras() {
    if (selectedSubjects.isEmpty) {
      Get.snackbar('Champ requis', 'Ajoutez au moins une matière.');
      return false;
    }
    return true;
  }

  bool validateMentorExtras() {
    if (mentorLevel.value == 'Sélectionnez votre niveau') {
      Get.snackbar('Champ requis', 'Sélectionnez votre niveau d\'études.');
      return false;
    }
    if (selectedExpertises.isEmpty) {
      Get.snackbar('Champ requis', 'Ajoutez au moins un domaine d\'expertise.');
      return false;
    }
    return true;
  }

  Future<void> submitForm({required bool isStudent}) async {
    if (!_auth.isLoggedIn) {
      Get.snackbar('Erreur', 'Session expirée. Créez d\'abord votre compte.');
      Get.offAllNamed(Routes.register);
      return;
    }

    final fieldsValid = formKey.currentState?.validate() ?? false;
    if (!fieldsValid) return;

    final extrasValid =
        isStudent ? validateStudentExtras() : validateMentorExtras();
    if (!extrasValid) return;

    isLoading.value = true;
    try {
      final current = _auth.user.value;
      final uid = _auth.uid;
      if (uid == null) throw Exception('Session introuvable');

      final profile = UserModel(
        id: uid,
        email: current?.email ?? '',
        displayName: current?.displayName ?? '',
        photoUrl: current?.photoUrl,
        university: establishmentController.text.trim(),
        level: isStudent ? studentLevel.value : mentorLevel.value,
        subjects: isStudent
            ? selectedSubjects.toList()
            : selectedExpertises.toList(),
        bio: isStudent
            ? studentDescriptionController.text.trim()
            : presentationController.text.trim(),
        isOnline: true,
      );
      await _users.updateMe(profile);

      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    establishmentController.dispose();
    specialtyController.dispose();
    subjectController.dispose();
    expertiseController.dispose();
    mentorPresentationController.dispose();
    studentDescriptionController.dispose();
    presentationController.dispose();
    super.onClose();
  }
}
