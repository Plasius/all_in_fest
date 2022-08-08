import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/pages/home_page.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loadHome(),
    );
  }

  StatefulWidget loadHome() {
    var appConfig = AppConfiguration("application-0-bjnqv");
    var app = App(appConfig);

    if (app.currentUser == null) {
      RealmConnect.currentUser = app.currentUser;
      return const LoginPage();
    } else {
      return const MyHomePage();
    }
  }
}
