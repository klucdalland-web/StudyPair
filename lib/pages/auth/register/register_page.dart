import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/auth/register/widgets/profile_selector.dart';
import 'package:study_pair/pages/auth/register/widgets/register_footer.dart';
import 'package:study_pair/pages/auth/register/widgets/register_form.dart';
import 'package:study_pair/pages/auth/register/widgets/register_header.dart';

import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../../../widgets/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // État pour la sélection du profil (true = Étudiant, false = Mentor)
  bool _isStudentSelected = true;

  // État pour la case à cocher RGPD
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RegisterHeader(),
            const VGap.xl(),

            // Section Choix du profil
            ProfileSelector(
              isStudentSelected: _isStudentSelected,
              onProfileSelected: (bool isStudent) {
                setState(() {
                  _isStudentSelected = isStudent;
                });
              },
            ),

            const VGap.xl(),

            // Formulaire d'inscription
            RegisterForm(
              acceptTerms: _acceptTerms,
              onTermsChanged: (bool? value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              onSubmit: () {
                Get.toNamed(Routes.registerStepTwo, arguments: {'isStudent': _isStudentSelected});
              },
            ),

            const VGap.xl(),
            const RegisterFooter(),
            const VGap.xxl(),
          ],
        ),
      ),
    );
  }
}
