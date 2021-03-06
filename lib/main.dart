import 'package:all_in_fest/pages/chat_page.dart';
import 'package:all_in_fest/pages/events_page.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:all_in_fest/pages/menu_sidebar.dart';
import 'package:all_in_fest/pages/profile_page.dart';
import 'package:all_in_fest/pages/register_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'models/favorite_model.dart';
import 'models/mongo_connect.dart';
import 'pages/map_page.dart';
import 'pages/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (err) {
    //might have been initialized before
  }
  await MongoDatabase.connect();

  runApp(ChangeNotifierProvider(
      create: (context) => FavoriteModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const MyHomePage(title: 'Flutter Demo Home Page')
          : LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        drawer: MenuBar(
            imageProvider: MongoDatabase.picture != null
                ? MongoDatabase.picture!
                : AssetImage("lib/assets/user.png"),
            userName: FirebaseAuth.instance.currentUser != null
                ? MongoDatabase.currentUser["name"]
                : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
            email: FirebaseAuth.instance.currentUser != null
                ? MongoDatabase.email!
                : ""), //MongoDatabase.email!),
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
                  child: const Center(child: Text("T??rk??p")),
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
