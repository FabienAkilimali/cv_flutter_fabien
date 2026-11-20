
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? photoProfil;

  String nom = 'Fabien Akilimali';
  String titre = 'Étudiant en informatique | Développeur';
  String apropos =
      'Passionné par le développement logiciel, les réseaux informatiques '
      'et la cybersécurité.';

  final List<String> formations = [
    'ISIG Goma - Licence 3, Informatique, option systèmes informatiques',
  ];

  final List<String> competences = [
    'Dart et Flutter',
    'Python et C#',
    'SQL Server et MySQL',
    'Cisco Packet Tracer',
    'MikroTik et Ubiquiti',
    'Windows et Linux',
  ];

  final List<String> projets = [
    'Application de gestion bancaire avec C# et SQL Server',
    'Mutu Found - Gestion d’un fonds communautaire avec AppSheet',
    'Application CV avec Flutter',
    'Laboratoires de configuration réseaux',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Sélectionner une photo depuis la galerie
  Future<void> choisirPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();

        if (!mounted) return;

        setState(() {
          photoProfil = imageBytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de sélectionner la photo : $e'),
        ),
      );
    }
  }

  // Supprimer la photo
  void supprimerPhoto() {
    setState(() {
      photoProfil = null;
    });
  }

  Future<String?> demanderTexte({
    required String titre,
    String valeurInitiale = '',
    String indication = '',
  }) async {
    final controller = TextEditingController(text: valeurInitiale);

    final resultat = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titre),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: indication,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text.trim());
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    controller.dispose();
    return resultat;
  }

  Future<void> ajouterElement(
    List<String> liste,
    String titre,
  ) async {
    final texte = await demanderTexte(
      titre: titre,
      indication: 'Saisir une information',
    );

    if (texte != null && texte.isNotEmpty) {
      setState(() => liste.add(texte));
    }
  }

  Future<void> modifierProfil() async {
    final nouveauNom = await demanderTexte(
      titre: 'Modifier le nom',
      valeurInitiale: nom,
    );

    if (nouveauNom != null && nouveauNom.isNotEmpty) {
      setState(() => nom = nouveauNom);
    }

    if (!mounted) return;

    final nouveauTitre = await demanderTexte(
      titre: 'Modifier le titre professionnel',
      valeurInitiale: titre,
    );

    if (nouveauTitre != null && nouveauTitre.isNotEmpty) {
      setState(() => titre = nouveauTitre);
    }

    if (!mounted) return;

    final nouvelleDescription = await demanderTexte(
      titre: 'Modifier la présentation',
      valeurInitiale: apropos,
    );

    if (nouvelleDescription != null &&
        nouvelleDescription.isNotEmpty) {
      setState(() => apropos = nouvelleDescription);
    }
  }

  Widget construireSection({
    required String titre,
    required IconData icone,
    required List<String> elements,
    required String texteBouton,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(icone, color: Colors.blue),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                titre,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              tooltip: texteBouton,
              onPressed: () => ajouterElement(elements, texteBouton),
              icon: const Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        if (elements.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Aucune information ajoutée.'),
          ),
        ...elements.asMap().entries.map((entry) {
          return Card(
            child: ListTile(
              title: Text(entry.value),
              trailing: IconButton(
                tooltip: 'Supprimer',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    elements.removeAt(entry.key);
                  });
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon curriculum vitae'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Modifier mon profil',
            onPressed: modifierProfil,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PHOTO ET INFORMATIONS DU CANDIDAT
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        backgroundImage: photoProfil != null
                            ? MemoryImage(photoProfil!)
                            : null,
                        child: photoProfil == null
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      CircleAvatar(
                        radius: 19,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          tooltip: 'Choisir ou remplacer la photo',
                          padding: EdgeInsets.zero,
                          onPressed: choisirPhoto,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  OutlinedButton.icon(
                    onPressed: choisirPhoto,
                    icon: const Icon(Icons.photo_library),
                    label: Text(
                      photoProfil == null
                          ? 'Choisir une photo'
                          : 'Remplacer la photo',
                    ),
                  ),

                  if (photoProfil != null)
                    TextButton.icon(
                      onPressed: supprimerPhoto,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Supprimer la photo',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 14),

                  Text(
                    nom,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    titre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.blue),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    apropos,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: modifierProfil,
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier mon profil'),
                  ),
                ],
              ),
            ),

            // FORMATION
            construireSection(
              titre: 'Formation',
              icone: Icons.school,
              elements: formations,
              texteBouton: 'Ajouter une formation',
            ),

            // COMPETENCES
            construireSection(
              titre: 'Compétences',
              icone: Icons.computer,
              elements: competences,
              texteBouton: 'Ajouter une compétence',
            ),

            // PROJETS
            construireSection(
              titre: 'Projets réalisés',
              icone: Icons.work,
              elements: projets,
              texteBouton: 'Ajouter un projet',
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'Curriculum Vitae',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // BOUTON RETOUR EN HAUT
      floatingActionButton: FloatingActionButton.small(
        tooltip: 'Retour en haut',
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}

