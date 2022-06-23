import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'matches_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = "";
  String password = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
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
            const Text("Name"),
            TextFormField(onChanged: (value) {
              name = value;
            }),
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
              onPressed: () => signInUsingEmailPassword(
                  name: name,
                  email: email,
                  password: password,
                  context: context),
            ),
          ]),
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  void signInUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => {createFirestoreProfile()});
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
  }

  void createFirestoreProfile() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .set({
      'name': name,
      'bio': "",
      'photo': "",
      'since': DateTime.now().millisecondsSinceEpoch
    });

    final prefs = await SharedPreferences.getInstance();

    final int? counter = prefs.getInt('counter');
    if (counter == null) {
      await prefs.setInt('counter', 0);
    }
  }
}
