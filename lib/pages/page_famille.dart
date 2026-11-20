
import 'package:material_ui/material_ui.dart';

class MembreFamille {
  String nom;
  String relation;
  String profession;

  MembreFamille({
    required this.nom,
    required this.relation,
    required this.profession,
  });
}

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  final List<MembreFamille> membres = [
    MembreFamille(
      nom: 'Nom du père',
      relation: 'Père',
      profession: 'Profession à compléter',
    ),
    MembreFamille(
      nom: 'Nom de la mère',
      relation: 'Mère',
      profession: 'Profession à compléter',
    ),
    MembreFamille(
      nom: 'Nom du frère',
      relation: 'Frère',
      profession: 'Profession à compléter',
    ),
    MembreFamille(
      nom: 'Nom de la sœur',
      relation: 'Sœur',
      profession: 'Profession à compléter',
    ),
  ];

  IconData iconeRelation(String relation) {
    switch (relation) {
      case 'Père':
        return Icons.man;
      case 'Mère':
        return Icons.woman;
      case 'Frère':
        return Icons.boy;
      case 'Sœur':
        return Icons.girl;
      default:
        return Icons.person;
    }
  }

  Future<void> formulaireMembre({int? index}) async {
    final membre = index == null ? null : membres[index];

    final nomController = TextEditingController(
      text: membre?.nom ?? '',
    );
    final professionController = TextEditingController(
      text: membre?.profession ?? '',
    );

    String relation = membre?.relation ?? 'Père';

    final resultat = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, actualiser) => AlertDialog(
          title: Text(
            index == null ? 'Ajouter un membre' : 'Modifier le membre',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
               DropdownButtonFormField<String>(
                  initialValue: relation,
                  decoration: const InputDecoration(
                    labelText: 'Relation familiale',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Père', child: Text('Père')),
                    DropdownMenuItem(value: 'Mère', child: Text('Mère')),
                    DropdownMenuItem(value: 'Frère', child: Text('Frère')),
                    DropdownMenuItem(value: 'Sœur', child: Text('Sœur')),
                    DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                  ],
                  onChanged: (valeur) {
                    if (valeur != null) {
                      actualiser(() => relation = valeur);
                    }
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: professionController,
                  decoration: const InputDecoration(
                    labelText: 'Profession',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomController.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );

    if (resultat == true && mounted) {
      setState(() {
        final nouveauMembre = MembreFamille(
          nom: nomController.text.trim(),
          relation: relation,
          profession: professionController.text.trim(),
        );

        if (index == null) {
          membres.add(nouveauMembre);
        } else {
          membres[index] = nouveauMembre;
        }
      });
    }

    nomController.dispose();
    professionController.dispose();
  }

  void supprimerMembre(int index) {
    setState(() => membres.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma famille'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.family_restroom,
              size: 45,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Ma famille',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Découvrez les membres de ma famille.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () => formulaireMembre(),
            icon: const Icon(Icons.person_add),
            label: const Text('Ajouter un membre'),
          ),

          const SizedBox(height: 15),

          if (membres.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text('Aucun membre enregistré.'),
              ),
            ),

          ...membres.asMap().entries.map((entry) {
            final index = entry.key;
            final membre = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(
                    iconeRelation(membre.relation),
                    color: Colors.blue,
                  ),
                ),
                title: Text(
                  membre.nom,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${membre.relation} • ${membre.profession}',
                ),
                onTap: () => formulaireMembre(index: index),
                trailing: PopupMenuButton<String>(
                  onSelected: (choix) {
                    if (choix == 'modifier') {
                      formulaireMembre(index: index);
                    } else if (choix == 'supprimer') {
                      supprimerMembre(index);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'modifier',
                      child: Text('Modifier'),
                    ),
                    PopupMenuItem(
                      value: 'supprimer',
                      child: Text('Supprimer'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
