import 'package:all_in_fest/pages/events_page.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:all_in_fest/pages/map_page.dart';
import 'package:all_in_fest/pages/profile_page.dart';
import 'package:all_in_fest/pages/register_page.dart';
import 'package:all_in_fest/pages/settings_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //MongoDatabase.connect();

  runApp(const MyApp());
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
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/home_bg.png"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: const Color.fromRGBO(97, 42, 122, .40),
                              border:
                                  Border.all(color: Colors.white, width: 3)),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.21,
                          child: Column(
                            children: [
                              Icon(Icons.developer_board,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.3),
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 1,
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EventsPage())),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: const Color.fromRGBO(97, 42, 122, .40),
                              border:
                                  Border.all(color: Colors.white, width: 3)),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.21,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(Icons.calendar_month,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.3),
                              Text(
                                "ESEMÉNYEK",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 1,
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: const Image(
                            image: AssetImage("lib/assets/leanykak.png")),
                      ),
                      const SizedBox(
                        width: 1,
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage())),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: const Color.fromRGBO(97, 42, 122, .40),
                              border:
                                  Border.all(color: Colors.white, width: 3)),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.21,
                          child: Column(
                            children: [
                              Icon(Icons.person,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.width * 0.3),
                              Text(
                                "PROFILE",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 1,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage())),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromRGBO(97, 42, 122, .40),
                            border: Border.all(color: Colors.white, width: 3)),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.21,
                        child: Column(
                          children: [
                            Icon(Icons.developer_board,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.3),
                            Text(
                              "REGISTER",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 1,
                      height: 20,
                    ),
                    const Text("HOME",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(
                      width: 1,
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SwipePage())),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromRGBO(97, 42, 122, .40),
                            border: Border.all(color: Colors.white, width: 3)),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.21,
                        child: Column(
                          children: [
                            Icon(Icons.people,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.3),
                            Text(
                              "MEETUP",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapPage())),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromRGBO(97, 42, 122, .40),
                            border: Border.all(color: Colors.white, width: 3)),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.21,
                        child: Column(
                          children: [
                            Icon(Icons.map,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.3),
                            Text(
                              "TÉRKÉP",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage())),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromRGBO(97, 42, 122, .40),
                            border: Border.all(color: Colors.white, width: 3)),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.21,
                        child: Column(
                          children: [
                            Icon(Icons.settings,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.3),
                            Text(
                              "BEÁLLÍTÁSOK",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )

        /*Center(
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
        )*/

        );
  }
}
