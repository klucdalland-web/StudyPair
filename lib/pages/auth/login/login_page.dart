import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 48),
            Text(
              'StudyPair',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Connecte-toi pour trouver un binôme'),
            const SizedBox(height: 32),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading
                    ? null
                    : () => _run(() => _auth.resetPassword(_email.text)),
                child: const Text('Mot de passe oublié ?'),
              ),
            ),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => _run(
                      () => _auth.signIn(_email.text, _password.text),
                    ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Se connecter'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loading
                  ? null
                  : () => _run(_auth.signInWithGoogle),
              child: const Text('Continuer avec Google'),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.register),
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
