import 'package:flutter/material.dart';
import '../../models/demande_model.dart';
import '../../theme/app_colors.dart';
import './planning_fake_data/fetch_fake_planning_data.dart';
import './widgets/emptyState.dart';
import './widgets/demandeCard.dart';
import './widgets/tab_buttons.dart';
// import '../../theme/app_colors.dart';
// import '../../widgets/app_platform.dart';
// import '../../widgets/gap.dart';

// class PlanningPage extends StatelessWidget {
//   const PlanningPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppTabScaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Planning',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const VGap.sm(),
//             const Text(
//               'Organise tes sessions de révision.',
//               style: TextStyle(color: AppColors.textSecondary),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List<DemandeModel> _demandes = buildMockDemandes();
  bool _showRecues = true;

  List<DemandeModel> get _recuesEnAttente => _demandes
      .where((d) => d.estRecuePar(currentUserId) && d.estEnAttente)
      .toList();

  List<DemandeModel> get _envoyees =>
      _demandes.where((d) => d.estEnvoyeePar(currentUserId)).toList();

  void _updateStatus(String demandeId, String status) {
    setState(() {
      _demandes = _demandes
          .map((d) => d.id == demandeId ? d.copyWith(status: status) : d)
          .toList();
    });
  }

  void _onAccepter(DemandeModel d) => _updateStatus(d.id, DemandeStatus.accepted);

  void _onDecliner(DemandeModel d) => _updateStatus(d.id, DemandeStatus.declined);

  @override
  Widget build(BuildContext context) {
    final list = _showRecues ? _recuesEnAttente : _envoyees;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 16),
            if (list.isEmpty)
              const EmptyState()
            else
              ...list.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DemandeCard(
                    demande: d,
                    sender: mockSenders[d.senderId],
                    onAccepter: () => _onAccepter(d),
                    onDecliner: () => _onDecliner(d),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            _buildFooterNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Demandes',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.badgeBlueBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '${_recuesEnAttente.length + _envoyees.length} actives',
            style: const TextStyle(
              color: AppColors.badgeBlueText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: TabButton(
            label: 'Reçues',
            count: _recuesEnAttente.length,
            selected: _showRecues,
            onTap: () => setState(() => _showRecues = true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TabButton(
            label: 'Envoyées',
            count: _envoyees.length,
            selected: !_showRecues,
            onTap: () => setState(() => _showRecues = false),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterNote() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            'Les demandes expirent automatiquement après 5 jours sans réponse.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Un engagement rapide renforce la réputation de votre profil StudyPair.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

