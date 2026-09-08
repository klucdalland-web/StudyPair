import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _users = Get.find<UserService>();
  final _name = TextEditingController();
  final _bio = TextEditingController();
  final _university = TextEditingController();
  final _level = TextEditingController();
  final _subjects = TextEditingController();

  UserModel? _user;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await _users.getMe();
      _user = user;
      _name.text = user.displayName;
      _bio.text = user.bio ?? '';
      _university.text = user.university ?? '';
      _level.text = user.level ?? '';
      _subjects.text = user.subjects.join(', ');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_user == null) return;
    setState(() => _saving = true);
    try {
      final subjects = _subjects.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      await _users.updateMe(
        _user!.copyWith(
          displayName: _name.text.trim(),
          bio: _bio.text.trim(),
          university: _university.text.trim(),
          level: _level.text.trim(),
          subjects: subjects,
        ),
      );
      Get.snackbar('OK', 'Profil mis à jour');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _university.dispose();
    _level.dispose();
    _subjects.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.find<AuthService>().signOut();
              Get.offAllNamed(Routes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _university,
                  decoration: const InputDecoration(labelText: 'Université'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _level,
                  decoration: const InputDecoration(labelText: 'Niveau'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _subjects,
                  decoration: const InputDecoration(
                    labelText: 'Matières (séparées par des virgules)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bio,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Enregistrement...' : 'Enregistrer'),
                ),
              ],
            ),
    );
  }
}
