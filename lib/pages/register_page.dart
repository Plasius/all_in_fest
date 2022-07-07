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
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.019,
                      right: MediaQuery.of(context).size.width * 0.019,
                      top: MediaQuery.of(context).size.height * 0.033,
                      bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(97, 42, 122, 1),
                        borderRadius: BorderRadius.circular(5)),
                    height: MediaQuery.of(context).size.height * 0.72,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.027,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.022),
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
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.043,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.011),
                              child: const Text(
                                "Név",
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
                                  bottom: size.width * 0.041),
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
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  MediaQuery.of(context).size.width * 0.043,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.011),
                              child: const Text(
                                "Jelszó újra",
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
                                  bottom: size.width * 0.0205),
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
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.white,
                              checkColor: Colors.orange,
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 3), //  <-- leading Checkbox
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height*0.009, horizontal: size.width*0.065),
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
                padding: EdgeInsets.only(top: size.height*0.04, right: size.height*0.022),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height*0.013),
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
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
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
