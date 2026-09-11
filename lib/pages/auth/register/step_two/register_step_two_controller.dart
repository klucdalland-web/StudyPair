import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/services/auth_service.dart';

class RegisterStepTwoController extends AuthService {
  final formKey = GlobalKey<FormState>();

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

  // Méthodes de mise à jour
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

  void submitForm({required bool isStudent}) {
    
    final fieldsValid = formKey.currentState?.validate() ?? false;
    
    if (!fieldsValid) return;

    final extrasValid =
        isStudent ? validateStudentExtras() : validateMentorExtras();
    if (!extrasValid) return;


    Get.snackbar('Succès', 'Inscription finalisée avec succès !');
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
