import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:study_pair/pages/auth/login/widgets/login_card.dart';
import 'package:study_pair/pages/auth/login/widgets/login_footer.dart';
import 'package:study_pair/pages/auth/login/widgets/login_header_widget.dart';
import 'package:study_pair/pages/auth/login/widgets/trust_button.dart';

import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_scaffold.dart';
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
  bool _obscurePassword = true;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _loading = true);

    try {
      await action();
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar('Erreurs', e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
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

          const LoginHeader(),

          const VGap.xxl(),

          LoginCard(
            emailController: _email,
            passwordController: _password,
            obscurePassword: _obscurePassword,
            loading: _loading,
            onToggleObscure: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            onGoogleSignIn: () => _run(_auth.signInWithGoogle),
            onForgotPassword: () =>
                _run(() => _auth.resetPassword(_email.text)),
            onSubmit: () =>
                _run(() => _auth.signIn(_email.text, _password.text)),
          ),

          const VGap.xl(),

          const TrustBadge(),

          const VGap.xl(),

          LoginFooter(onRegister: () => Get.toNamed(Routes.register)),
        ],
      ),
    );
  }
}
