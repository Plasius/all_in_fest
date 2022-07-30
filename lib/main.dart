import 'package:all_in_fest/pages/events_page.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:all_in_fest/pages/profile_page.dart';
import 'package:all_in_fest/pages/register_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';

import 'models/favorite_model.dart';
import 'pages/map_page.dart';
import 'pages/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //MongoDatabase.connect();

  runApp(ChangeNotifierProvider(
      create: (context) => FavoriteModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfiguration("application-0-bjnqv");
    var app = App(appConfig);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: app.currentUser != null
          ? const MyHomePage(title: 'Festival')
          : const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* drawer: MenuBar(
            imageProvider: MongoDatabase.picture != null
                ? MongoDatabase.picture!
                : AssetImage("lib/assets/user.png"),
            userName: FirebaseAuth.instance.currentUser != null
                ? MongoDatabase.currentUser["name"]!
                : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
            email: FirebaseAuth.instance.currentUser != null
                ? MongoDatabase.email!
                : ""), //MongoDatabase.email!), */
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
          title: const Image(
            image: AssetImage("lib/assets/logo.png"),
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Login page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Register page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MatchesPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Matches page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
/*
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ChatPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Chat page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
*/
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Profile page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Settings page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EventsPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Events page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SwipePage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Swipe page")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapPage())),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Center(child: Text("Térkép")),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                ),
              ),
            ],
          ),
        ));
  }
}
