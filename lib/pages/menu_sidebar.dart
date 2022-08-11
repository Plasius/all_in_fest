import 'package:all_in_fest/pages/events_page.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:all_in_fest/pages/map_page.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:all_in_fest/pages/profile_page.dart';
import 'package:all_in_fest/pages/settings_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';

class MenuBar extends StatelessWidget {
  final ImageProvider imageProvider;
  final String? userName;
  const MenuBar(
      {Key? key,
      required this.imageProvider,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName!),
            accountEmail: null,
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(232, 107, 62, 1),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt),
            title: const Text('in/Touch'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SwipePage())),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Matches'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MatchesPage())),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Events'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EventsPage())),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Map'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MapPage())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage())),
          ),
          const Divider(),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()))
            },
          ),
        ],
      ),
    );
  }
}
