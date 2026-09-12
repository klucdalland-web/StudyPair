import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/home/widgets/header.dart';
import 'package:study_pair/pages/dashboard/home/widgets/search.dart';
import 'package:study_pair/pages/dashboard/match/widgets/correspondance.dart';
import 'package:study_pair/pages/dashboard/match/widgets/match_users_skeleton.dart';
import 'package:study_pair/pages/dashboard/match/widgets/mesmachts.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/gap.dart';

import '../../../services/match_service.dart';
import '../../../services/user_service.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  static const _pageSize = 12;

  final _users = Get.find<UserService>();
  final _matches = Get.find<MatchService>();
  final _scrollController = ScrollController();

  List<UserModel> _partners = [];
  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;

  Future<void> _loadUsers({bool refresh = false}) async {
    if (refresh) {
      _lastDoc = null;
      _hasMore = true;
      setState(() => _loading = true);
    }

    try {
      final page = await _users.searchPartnersPage(limit: _pageSize);
      if (!mounted) return;
      setState(() {
        _partners = page.users;
        _lastDoc = page.lastDoc;
        _hasMore = page.hasMore;
      });
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore || _loading) return;

    setState(() => _loadingMore = true);
    try {
      final page = await _users.searchPartnersPage(
        limit: _pageSize,
        startAfter: _lastDoc,
      );
      if (!mounted) return;

      final existingIds = _partners.map((u) => u.id).toSet();
      final next = page.users.where((u) => !existingIds.contains(u.id)).toList();

      setState(() {
        _partners = [..._partners, ...next];
        _lastDoc = page.lastDoc;
        _hasMore = page.hasMore && page.users.isNotEmpty;
      });
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _loadMore();
    }
  }

  Future<void> _request(UserModel partner, {String message = ''}) async {
    try {
      final subject = partner.subjects.isNotEmpty
          ? partner.subjects.first
          : 'Général';
      await _matches.requestMatch(partnerId: partner.id, subject: subject);
      final suffix = message.isEmpty
          ? ''
          : ' — « ${message.length > 40 ? '${message.substring(0, 40)}…' : message} »';
      Get.snackbar('Match', 'Demande envoyée à ${partner.displayName}$suffix');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadUsers();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
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
              child: _loading
                  ? const MatchUsersSkeleton()
                  : RefreshIndicator(
                      onRefresh: () => _loadUsers(refresh: true),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MesMatchsComplet(count: _partners.length),
                            MeilleuresCorrespondancesSection(
                              users: _partners,
                              onProposer: _request,
                            ),
                            if (_loadingMore) const MatchLoadMoreSkeleton(),
                            if (!_hasMore && _partners.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 28),
                                child: Center(
                                  child: Text(
                                    'Tous les profils sont chargés',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
