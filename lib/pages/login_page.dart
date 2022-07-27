import 'package:all_in_fest/pages/menu_sidebar.dart';
import 'package:all_in_fest/pages/profile_page.dart';
import 'package:all_in_fest/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import '../models/mongo_connect.dart';
import 'matches_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  String email = "";
  String password = "";
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          constraints: BoxConstraints.tight(MediaQuery.of(context).size),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/LOGIN.png"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.0386,
                        right: size.width * 0.0386,
                        top: size.height * 0.25,
                        bottom: size.height * 0.1),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(97, 42, 122, 1),
                          borderRadius: BorderRadius.circular(5)),
                      height: MediaQuery.of(context).size.height * 0.46,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * 0.037,
                                    bottom: size.height * 0.022),
                                child: Center(
                                  child: const Text(
                                    "Bejelentkezés",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.043,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.011),
                                child: const Text(
                                  "E-mail cím",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.041,
                                    right: size.width * 0.041,
                                    bottom: size.width * 0.041),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                      border: Border.all(
                                          color: Colors.white, width: 3),
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
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.043,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.011),
                                child: const Text(
                                  "Jelszó",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.041,
                                    right: size.width * 0.041,
                                    bottom: size.width * 0.082),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                      border: Border.all(
                                          color: Colors.white, width: 3),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.009,
                                          horizontal: size.width * 0.065),
                                      child: const Text(
                                        "Belépés",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32),
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
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.035, right: size.height * 0.022, bottom: size.height * 0.035),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: size.height * 0.013),
                            child: const Text("Még nincs fiókod?",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20)),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage())),
                            child: const Text(
                              "Regisztráció",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )
                        ]),
                  ),
                )
              ],
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

      MongoDatabase.disconnect();
      await MongoDatabase.connect();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print(e);
      }
    }
  }
}
