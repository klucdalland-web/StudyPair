import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = Get.find<AuthService>();
  bool _loading = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: AppPageScroll(
        children: [
          const VGap.xxl(),
          Text(
            'StudyPair',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const VGap.sm(),
          const Text(
            'Connecte-toi pour trouver un binôme',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const VGap.xxl(),
          AppTextField(
            controller: _email,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const VGap.md(),
          AppTextField(
            controller: _password,
            label: 'Mot de passe',
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _run(
              () => _auth.signIn(_email.text, _password.text),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton.ghost(
              label: 'Mot de passe oublié ?',
              onPressed: _loading
                  ? null
                  : () => _run(() => _auth.resetPassword(_email.text)),
            ),
          ),
          AppButton(
            label: 'Se connecter',
            loading: _loading,
            onPressed: () => _run(
              () => _auth.signIn(_email.text, _password.text),
            ),
          ),
          const VGap.md(),
          AppButton.secondary(
            label: 'Continuer avec Google',
            loading: _loading,
            onPressed: () => _run(_auth.signInWithGoogle),
          ),
          AppButton.ghost(
            label: 'Créer un compte',
            onPressed: () => Get.toNamed(Routes.register),
          ),
        ],
      ),
    );
  }
}
