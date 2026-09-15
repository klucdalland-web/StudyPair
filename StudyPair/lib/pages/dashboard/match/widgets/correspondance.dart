import 'package:flutter/material.dart';

class MeilleuresCorrespondancesSection extends StatelessWidget {
  const MeilleuresCorrespondancesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives extraites directement de votre maquette Figma
    final List<Map<String, dynamic>> correspondances = [
      {
        'nom': 'Sarah L.',
        'affinite': '98%',
        'statut': 'M2 Data Science & IA • Sorbonne',
        'description': 'Projets Python, Machine Learning & révision d\'examens',
        'competences': ['Python', 'Algorithmes'],
        'dejaFavoris': false,
      },
      {
        'nom': 'Alexandre D.',
        'affinite': '94%',
        'statut': 'M1 Génie Logiciel • Paris-Saclay',
        'description': 'Préparation conjointe du projet d\'ingénierie logicielle.',
        'competences': ['Java & C++', 'Git'],
        'dejaFavoris': false,
      },
      {
        'nom': 'Camille R.',
        'affinite': '91%',
        'statut': 'M2 Maths Appliquées • Paris Cité',
        'description': 'Co-working silencieux et révision des partiels.',
        'competences': ['Probabilités', 'LaTeX'],
        'dejaFavoris': true, // Pour illustrer un cœur déjà sélectionné
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. EN-TÊTE : Titre et option de tri
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Meilleures correspondances',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Par affinité',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. LISTE VERTICALE DES CARTES PROFIL
        ListView.builder(
          shrinkWrap: true, // Permet d'intégrer la liste dans une Column globale
          physics: const NeverScrollableScrollPhysics(), // Laisse le défilement au parent principal
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: correspondances.length,
          itemBuilder: (context, index) {
            final profil = correspondances[index];
            return ProfilMatchCard(
              nom: profil['nom'],
              affinite: profil['affinite'],
              statut: profil['statut'],
              description: profil['description'],
              competences: List<String>.from(profil['competences']),
              dejaFavoris: profil['dejaFavoris'],
            );
          },
        ),
      ],
    );
  }
}

// Composant individuel pour chaque profil de correspondance
class ProfilMatchCard extends StatefulWidget {
  final String nom;
  final String affinite;
  final String statut;
  final String description;
  final List<String> competences;
  final bool dejaFavoris;

  const ProfilMatchCard({
    Key? key,
    required this.nom,
    required this.affinite,
    required this.statut,
    required this.description,
    required this.competences,
    required this.dejaFavoris,
  }) : super(key: key);

  @override
  State<ProfilMatchCard> createState() => _ProfilMatchCardState();
}

class _ProfilMatchCardState extends State<ProfilMatchCard> {
  late bool estFavoris;

  @override
  void initState() {
    super.initState();
    estFavoris = widget.dejaFavoris;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne 1 : Avatar, Nom/Statut et Bouton Cœur
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.nom,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.affinite,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.statut,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Icône Cœur cliquable
              IconButton(
                onPressed: () {
                  setState(() {
                    estFavoris = !estFavoris;
                  });
                },
                icon: Icon(
                  estFavoris ? Icons.favorite : Icons.favorite_border,
                  color: estFavoris ? Colors.red : Colors.grey.shade400,
                  size: 22,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ligne 2 : Description courte du projet/besoin
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),

          // Ligne 3 : Les badges d'aptitudes et le bouton "Proposer"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Liste horizontale des compétences (Tags)
              Expanded(
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: widget.competences.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Bouton "Proposer" à droite
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_rounded, size: 14, color: Color(0xFF636AE8)),
                label: const Text(
                  'Proposer',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF636AE8),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
