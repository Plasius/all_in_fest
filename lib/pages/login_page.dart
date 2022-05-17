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
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
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

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MatchesPage()));
  }
}
