import 'package:flutter/material.dart';

import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

enum DemandeTagType { algorithmique, mentorat, machineLearning, binome }

class DemandeTagChip extends StatelessWidget {
  const DemandeTagChip({super.key, required this.label, required this.type});

  final String label;
  final DemandeTagType type;

  _TagPalette get _palette {
    switch (type) {
      case DemandeTagType.algorithmique:
        return const _TagPalette(
          background: Color(0xFFE3ECFE),
          foreground: Color(0xFF3B6FE0),
          icon: Icons.data_object,
        );

      case DemandeTagType.mentorat:
        return const _TagPalette(
          background: Color(0xFFEDE7FE),
          foreground: Color(0xFF7C5CE0),
          icon: Icons.school_outlined,
        );

      case DemandeTagType.machineLearning:
        return const _TagPalette(
          background: Color(0xFFDFF4F4),
          foreground: Color(0xFF2E9E9E),
          icon: Icons.psychology_outlined,
        );

      case DemandeTagType.binome:
        return const _TagPalette(
          background: Color(0xFFDFF6E6),
          foreground: Color(0xFF2FA85B),
          icon: Icons.groups_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(palette.icon, size: 14, color: palette.foreground),
          const HGap.xs(),
          AppText(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: palette.foreground,
          ),
        ],
      ),
    );
  }
}

class _TagPalette {
  const _TagPalette({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}
