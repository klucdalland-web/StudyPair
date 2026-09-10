import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterStepTwoController extends GetxController {
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
  final RxList<String> selectedObjectives = <String>[
    'Comprendre les cours & TD',
    'Préparation aux partiels',
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

  void toggleObjective(String objective) {
    if (selectedObjectives.contains(objective)) {
      selectedObjectives.remove(objective);
    } else {
      selectedObjectives.add(objective);
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

  void submitForm() {
    Get.snackbar('Succès', 'Inscription finalisée avec succès !');
  }

  @override
  void onClose() {
    establishmentController.dispose();
    expertiseController.dispose();
    presentationController.dispose();
    super.onClose();
  }
}
