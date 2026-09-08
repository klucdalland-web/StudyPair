import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('StudyPair')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final name = auth.user.value?.displayName ?? 'toi';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bonjour $name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Trouve un partenaire pour réviser.'),
            ],
          );
        }),
      ),
    );
  }
}
