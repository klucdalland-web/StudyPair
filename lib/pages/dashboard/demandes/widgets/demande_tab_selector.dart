import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_chip.dart';
import 'package:study_pair/widgets/gap.dart';

class DemandesTabSelector extends StatelessWidget {
  const DemandesTabSelector({
    super.key,
    required this.selectedIndex,
    required this.recuesCount,
    required this.envoyeesCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int recuesCount;
  final int envoyeesCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppChip(
          label: recuesCount > 0 ? 'Reçues ($recuesCount)' : 'Reçues',
          selected: selectedIndex == 0,
          onTap: () => onChanged(0),
        ),
        const HGap.sm(),
        AppChip(
          label: envoyeesCount > 0 ? 'Envoyées ($envoyeesCount)' : 'Envoyées',
          selected: selectedIndex == 1,
          onTap: () => onChanged(1),
        ),
      ],
    );
  }
}
