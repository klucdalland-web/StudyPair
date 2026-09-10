import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/dashboard/home/widgets/categorieSection.dart';
import 'package:study_pair/pages/dashboard/home/widgets/demandesrecentes.dart';
import 'package:study_pair/pages/dashboard/home/widgets/header.dart';
import 'package:study_pair/pages/dashboard/home/widgets/search.dart';
import 'package:study_pair/pages/dashboard/match/widgets/correspondance.dart';
import 'package:study_pair/pages/dashboard/match/widgets/mesmachts.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/gap.dart';

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
    return AppTabScaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(),
          const VGap.md(),
          const Search(),
          const VGap.xl(),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                physics: AppPlatform.scrollPhysics,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MesMatchsComplet(),
                    MeilleuresCorrespondancesSection()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    
    
    
    // Scaffold(
    //   appBar: AppBar(title: const Text('Trouver un binôme')),
    //   body: MesMatchsComplet(),
    // );
  }
}
