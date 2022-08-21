import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';

import 'models/open_realm.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

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
      debugShowCheckedModeBanner: false,
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

    if (app.currentUser != null) {
      RealmConnect.currentUser = app.currentUser;
      RealmConnect.app = app;
      return const MyHomePage();
    } else {
      RealmConnect.currentUser = null;
      return const LoginPage();
    }
  }
}
