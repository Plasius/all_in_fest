import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/mongo_connect.dart';
import 'menu_sidebar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DateTime selectedDate = DateTime.now();

  var email_1 = TextEditingController();
  var email_2 = TextEditingController();
  var password_1 = TextEditingController();
  var password_2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : const AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""), //MongoDatabase.email!),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              leading: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: const Image(
                image: AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            body: editBody()));
  }

  Widget editBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: email_1,
              decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'radev.anthony@uni-corvinus.hu',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: email_2,
              decoration: InputDecoration(
                  labelText: 'E-mail újra',
                  labelStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'radev.anthony@uni-corvinus.hu',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: const Text('Frissítés'),
              onPressed: () => emailCsere(),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: password_1,
              decoration: InputDecoration(
                  labelText: 'Jelszó',
                  labelStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'wellbe#top100',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: password_2,
              decoration: InputDecoration(
                  labelText: 'Jelszó újra',
                  labelStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'wellbe#top100',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: const Text('Frissítés'),
              onPressed: () => jelszoCsere(),
            )
          ],
        ),
      ),
    );
  }

  void emailCsere() {
    if (email_1.text == email_2.text && email_1.text != "") {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      firebaseUser
          ?.updateEmail(email_1.text)
          .then(((value) => Fluttertoast.showToast(msg: "Sikeres módosítás")))
          .catchError(
              ((value) => Fluttertoast.showToast(msg: "Sikertelen módosítás")));
    }
  }

  void jelszoCsere() {
    if (password_1.text == password_2.text && password_1.text != '') {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      firebaseUser
          ?.updatePassword(password_1.text)
          .then(((value) => Fluttertoast.showToast(msg: "Sikeres módosítás")))
          .catchError(
              ((value) => Fluttertoast.showToast(msg: "Sikertelen módosítás")));
    }
  }
}
