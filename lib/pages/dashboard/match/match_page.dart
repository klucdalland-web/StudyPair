import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../services/match_service.dart';
import '../../../services/user_service.dart';
import 'widgets/partner_tile.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final _users = Get.find<UserService>();
  final _matches = Get.find<MatchService>();
  final _subject = TextEditingController();
  final _university = TextEditingController();
  final _level = TextEditingController();

  List<UserModel> _partners = [];
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      _partners = await _users.searchPartners(
        subject: _subject.text.trim(),
        university: _university.text.trim(),
        level: _level.text.trim(),
      );
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _request(UserModel partner) async {
    try {
      final subject = _subject.text.trim().isEmpty
          ? (partner.subjects.isNotEmpty ? partner.subjects.first : 'Général')
          : _subject.text.trim();
      await _matches.requestMatch(partnerId: partner.id, subject: subject);
      Get.snackbar('OK', 'Demande envoyée à ${partner.displayName}');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _subject.dispose();
    _university.dispose();
    _level.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trouver un binôme')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _subject,
                  decoration: const InputDecoration(labelText: 'Matière'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _university,
                        decoration: const InputDecoration(
                          labelText: 'Université',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _level,
                        decoration: const InputDecoration(labelText: 'Niveau'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loading ? null : _search,
                  child: const Text('Rechercher'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _partners.isEmpty
                ? const Center(child: Text('Aucun partenaire trouvé'))
                : ListView.builder(
                    itemCount: _partners.length,
                    itemBuilder: (_, i) {
                      final p = _partners[i];
                      return PartnerTile(
                        partner: p,
                        onRequest: () => _request(p),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
