import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'matches_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

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
                  image: AssetImage(
                      '/Users/dezsenyigyorgy/Documents/GitHub/all_in_fest/lib/assets/login_background.png'),
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
                        padding: const EdgeInsets.only(top: 24, bottom: 10),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                        child: const Text(
                          "E-mail",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 32),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            onChanged: (value) => email = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.mail_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 10),
                        child: const Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 48),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                              onChanged: (value) => password = value,
                              obscureText: _showPassword ? false : true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _togglevisibility();
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () => signInUsingEmailPassword(
                              context: context,
                              email: email,
                              password: password),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(254, 192, 1, 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 48),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34),
                              ),
                            ),
                          ),
                        ),
                      )
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
