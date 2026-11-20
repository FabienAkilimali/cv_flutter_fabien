
import 'package:material_ui/material_ui.dart';

import '../pages/page_accueil.dart';
import '../pages/page_famille.dart';
import '../pages/page_contact.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() =>
      _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int pageActuelle = 0;

  final List<Widget> pages = const [
    AccueilPage(),
    FamillePage(),
    ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageActuelle,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageActuelle,
        onTap: (index) {
          setState(() {
            pageActuelle = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon CV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}
