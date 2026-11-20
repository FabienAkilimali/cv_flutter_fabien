
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final Map<String, String> contacts = {
    'Nom complet': 'Fabien Akilimali',
    'Téléphone': 'À compléter',
    'Adresse e-mail': 'À compléter',
    'Localisation': 'À compléter',
    'GitHub': 'https://github.com/FabienAkilimali',
  };

  final Map<String, String> reseaux = {};

  final Map<String, IconData> icones = {
    'Nom complet': Icons.person,
    'Téléphone': Icons.phone,
    'Adresse e-mail': Icons.email,
    'Localisation': Icons.location_on,
    'GitHub': Icons.code,
  };

  Future<void> ouvrirLien(String valeur, String type) async {
    String adresse = valeur;

    if (type == 'Téléphone') {
      adresse = 'tel:$valeur';
    } else if (type == 'Adresse e-mail') {
      adresse = 'mailto:$valeur';
    } else if (!adresse.startsWith('http')) {
      adresse = 'https://$adresse';
    }

    final uri = Uri.tryParse(adresse);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’ouvrir cette adresse.'),
        ),
      );
    }
  }

  Future<void> modifierContact(String titre, String valeurActuelle) async {
    final controller = TextEditingController(text: valeurActuelle);

    final resultat = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Modifier : $titre'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: titre,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, controller.text.trim());
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (resultat != null && resultat.isNotEmpty && mounted) {
      setState(() {
        if (contacts.containsKey(titre)) {
          contacts[titre] = resultat;
        } else {
          reseaux[titre] = resultat;
        }
      });
    }

    controller.dispose();
  }

  Future<void> ajouterReseau() async {
    final nomController = TextEditingController();
    final lienController = TextEditingController();

    final resultat = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ajouter un réseau social'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du réseau',
                  hintText: 'Exemple : LinkedIn',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lienController,
                decoration: const InputDecoration(
                  labelText: 'Lien du profil',
                  hintText: 'https://...',
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
              if (nomController.text.trim().isEmpty ||
                  lienController.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );

    if (resultat == true && mounted) {
      setState(() {
        reseaux[nomController.text.trim()] =
            lienController.text.trim();
      });
    }

    nomController.dispose();
    lienController.dispose();
  }

  Widget construireContact(String titre, String valeur) {
    final icone = icones[titre] ?? Icons.link;

    final estCliquable = titre == 'GitHub' ||
        titre == 'Téléphone' ||
        titre == 'Adresse e-mail' ||
        reseaux.containsKey(titre);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icone, color: Colors.blue),
        ),
        title: Text(
          titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(valeur),
        onTap: estCliquable
            ? () => ouvrirLien(valeur, titre)
            : null,
        trailing: IconButton(
          tooltip: 'Modifier',
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => modifierContact(titre, valeur),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Me contacter'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.contact_mail,
              size: 55,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Restons en contact',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Retrouvez ici mes coordonnées personnelles et mes réseaux.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),

          const Text(
            'Mes coordonnées',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...contacts.entries.map(
            (entry) => construireContact(entry.key, entry.value),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Mes réseaux sociaux',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Ajouter un réseau',
                onPressed: ajouterReseau,
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          if (reseaux.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Aucun réseau social ajouté.'),
            ),

          ...reseaux.entries.map(
            (entry) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.link, color: Colors.white),
                ),
                title: Text(entry.key),
                subtitle: Text(entry.value),
                onTap: () => ouvrirLien(entry.value, entry.key),
                trailing: PopupMenuButton<String>(
                  onSelected: (choix) {
                    if (choix == 'modifier') {
                      modifierContact(entry.key, entry.value);
                    } else if (choix == 'supprimer') {
                      setState(() => reseaux.remove(entry.key));
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
            ),
          ),

          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Merci de votre visite !',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
