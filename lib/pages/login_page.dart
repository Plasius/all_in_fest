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
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/images/login_background.png"),
                  fit: BoxFit.cover)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8, top: 100, bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(97, 42, 122, 1),
                    borderRadius: BorderRadius.circular(5)),
                height: MediaQuery.of(context).size.height * 0.52,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 24),
                        child: Center(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Text("E-mail"),
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                            fillColor: Color.fromRGBO(255, 255, 255, 0.4),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3))),
                      ),
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
                                email: email,
                                password: password,
                                context: context);
                          } catch (e) {
                            print("whoops");
                          }
                        },
                      ),
                    ]),
              ),
            ),
          ),
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
