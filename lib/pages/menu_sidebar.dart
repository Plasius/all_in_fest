import 'package:all_in_fest/pages/chat_page.dart';
import 'package:all_in_fest/pages/events_page.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:all_in_fest/pages/map_page.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:all_in_fest/pages/profile_page.dart';
import 'package:all_in_fest/pages/settings_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MenuBar extends StatelessWidget {
  final ImageProvider imageProvider;
  final String userName;
  final String email;
  const MenuBar({Key? key, required this.imageProvider, required this.userName, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image(
                image: imageProvider,
              )),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(232, 107, 62, 1),
            ),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage())),
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt),
            title: Text('in/Touch'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SwipePage())),
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('Matches'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MatchesPage())),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Events'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EventsPage())),
          ),
          ListTile(
            leading: Icon(Icons.map_outlined),
            title: Text('Map'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MapPage())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsPage())),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfilePage())),
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => {
              FirebaseAuth.instance.signOut(),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: "Exited")))
            },
          ),
        ],
      ),
    );
  }
}
