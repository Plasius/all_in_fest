import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'matches_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";

    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
          leading: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          title: const Image(
            image: AssetImage("lib/assets/images/logo.png"),
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        body: Center(
          child: Column(children: [
            const Text("E-mail"),
            TextFormField(onChanged: (value) {
              email = value;
            }),
            const Text("Password"),
            TextFormField(
              onChanged: (value) {
                password = value;
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                try {
                  signInUsingEmailPassword(
                      email: email, password: password, context: context);
                } catch (e) {
                  print("whoops");
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  void signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MatchesPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
  }
}
