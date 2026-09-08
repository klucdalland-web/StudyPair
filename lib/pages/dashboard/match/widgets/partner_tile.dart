import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';

/// Ligne partenaire dans la recherche de binôme.
class PartnerTile extends StatelessWidget {
  const PartnerTile({
    super.key,
    required this.partner,
    required this.onRequest,
  });

  final UserModel partner;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      partner.university,
      partner.level,
      partner.subjects.take(3).join(', '),
    ].where((e) => e != null && e.toString().isNotEmpty).join(' · ');

    return ListTile(
      title: Text(partner.displayName),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.handshake),
        onPressed: onRequest,
      ),
    );
  }
}
