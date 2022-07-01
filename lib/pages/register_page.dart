import 'package:all_in_fest/pages/login_page.dart';
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
  bool checkedValue = false;

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    //String email = "";
    //String password = "";

    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/LOGIN.png"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 30, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(97, 42, 122, 1),
                        borderRadius: BorderRadius.circular(5)),
                    height: MediaQuery.of(context).size.height * 0.80,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 24, bottom: 20),
                              child: Center(
                                child: const Text(
                                  "Regisztráció",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 16.0, bottom: 10),
                              child: const Text(
                                "Név",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    border:
                                    Border.all(color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextFormField(
                                  onChanged: (value) => name = value,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, bottom: 10),
                              child: const Text(
                                "E-mail cím",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    border:
                                        Border.all(color: Colors.white, width: 3),
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
                                "Jelszó",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    border:
                                        Border.all(color: Colors.white, width: 3),
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
                            Padding(
                              padding: EdgeInsets.only(left: 16, bottom: 10),
                              child: const Text(
                                "Jelszó újra",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 24),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    border:
                                        Border.all(color: Colors.white, width: 3),
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
                            CheckboxListTile(
                              title: Text(
                                "Elfogadod az ÁSZF-et?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              value: checkedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  checkedValue = newValue!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading,
                              activeColor: Colors.white,
                              checkColor: Colors.orange,
                              side: BorderSide(
                                color: Colors.white,
                                width: 3
                              ),//  <-- leading Checkbox
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => registerUsingEmailPassword(
                                    name: name,
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
                                      "Regisztráció",
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
                padding: const EdgeInsets.only(top: 24.0, right: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text("Már van fiókod?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage())),
                          child: const Text(
                            "Belépés",
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
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  void registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    createFirestoreProfile();
    Navigator.pop(context);
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
      'since': DateTime.now().millisecondsSinceEpoch,
      'userID': auth.currentUser?.uid
    });

    final prefs = await SharedPreferences.getInstance();

    final int? counter = prefs.getInt('counter');
    if (counter == null) {
      await prefs.setInt('counter', 0);
    }
  }
}
