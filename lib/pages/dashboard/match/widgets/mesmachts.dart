import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/demande_controller.dart';
import 'package:study_pair/pages/dashboard/demandes/demandes_page.dart';
import 'package:study_pair/widgets/app_text.dart';

class MesMatchsComplet extends StatefulWidget {
  const MesMatchsComplet({Key? key}) : super(key: key);

  @override
  State<MesMatchsComplet> createState() => _MesMatchsCompletState();
}

class _MesMatchsCompletState extends State<MesMatchsComplet> {
  final List<String> filtres = [
    'Tous',
    '95%+ Affinité',
    'Informatique',
    'Mathématiques',
  ];

  int indexSelectionne = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. EN-TÊTE : Titre principal, Badge ET Bouton "Demandes"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Repousse le bouton à droite
            children: [
              // Partie Gauche : Titre + Badge
              Row(
                children: [
                   AppText(
                    'Mes Matchs',
                    // style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    // ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      '• 4 récents',
                      // style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w500,
                      // ),
                    ),
                  ),
                ],
              ),

              // Partie Droite : Le bouton "Demandes" manquant
              TextButton(
                onPressed: () {
                  Get.to<void>(
                    () => const DemandesPage(),
                    binding: DemandesBinding(),
                    preventDuplicates: true,
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Row(
                  children: const [
                    AppText(
                      'Demandes',
                      // style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      // ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: Colors.grey, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2. LA BARRE DE FILTRES (Tous, Informatique...)
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: filtres.length,
            itemBuilder: (context, index) {
              final estSelectionne = indexSelectionne == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    indexSelectionne = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: estSelectionne
                        ? const Color(0xFF636AE8)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: estSelectionne
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    filtres[index],
                    // style: TextStyle(
                      color: estSelectionne ? Colors.white : Colors.black87,
                      fontSize: 13,
                      fontWeight: estSelectionne
                          ? FontWeight.bold
                          : FontWeight.normal,
                    // ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Expanded(
        //   child: Container(
        //     child: SingleChildScrollView(
        //       child:MeilleuresCorrespondancesSection(),
        //     ),
        //   )
        //   )

        // 4. LISTE HORIZONTALE DES MATCHS
      ],
    );
  }
}
