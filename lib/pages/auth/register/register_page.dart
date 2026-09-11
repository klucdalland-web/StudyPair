import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/auth/register/widgets/profile_selector.dart';
import 'package:study_pair/pages/auth/register/widgets/register_footer.dart';
import 'package:study_pair/pages/auth/register/widgets/register_form.dart';
import 'package:study_pair/pages/auth/register/widgets/register_header.dart';
import 'package:study_pair/services/auth_service.dart';

import '../../../../routes/app_routes.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../../../widgets/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isStudentSelected = true;
  bool _acceptTerms = false;
  bool _loading = false;

  final _auth = Get.find<AuthService>();

  Future<void> _createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    setState(() => _loading = true);
    try {
      await _auth.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        isStudent: _isStudentSelected,
      );
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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

            ProfileSelector(
              isStudentSelected: _isStudentSelected,
              onProfileSelected: (bool isStudent) {
                setState(() => _isStudentSelected = isStudent);
              },
            ),

            const VGap.xl(),

            RegisterForm(
              acceptTerms: _acceptTerms,
              loading: _loading,
              onTermsChanged: (bool? value) {
                setState(() => _acceptTerms = value ?? false);
              },
              onSubmit: _createAccount,
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
