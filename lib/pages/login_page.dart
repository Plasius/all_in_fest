// ignore_for_file: avoid_print

import 'package:all_in_fest/models/realm_connect.dart';
import 'package:all_in_fest/pages/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          reverse: true,
          child: Container(
            constraints: BoxConstraints.tight(MediaQuery.of(context).size),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/LOGIN.png"),
                    fit: BoxFit.cover)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.0386,
                    right: size.width * 0.0386,
                    top: size.height * 0.2,
                    bottom: size.height * 0.1),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(97, 42, 122, 1),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.037,
                                bottom: size.height * 0.022),
                            child: const Center(
                              child: Text(
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
                                left: MediaQuery.of(context).size.width * 0.043,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.011),
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
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
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
                                left: MediaQuery.of(context).size.width * 0.043,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.011),
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
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: passwordController,
                                  obscureText: _showPassword ? false : true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(
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
                              onTap: login,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(254, 192, 1, 1),
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
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.020,
                                right: size.height * 0.022,
                                bottom: size.height * 0.035),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: size.height * 0.013),
                                      child: const Text("Még nincs fiókod?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage())),
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
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Nem megfelelően kitöltött mezők.");
      return;
    }

    Credentials emailPwCredentials = Credentials.emailPassword(
        emailController.text, passwordController.text);

    try {
      RealmConnect.realmUser =
          await App(AppConfiguration('application-0-bjnqv'))
              .logIn(emailPwCredentials);
      print(RealmConnect.realmUser.id);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Nem sikerült bejelentkezni.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return;
    }

    //create token for current device
    String? tokenString = await FirebaseMessaging.instance.getToken();

    if (tokenString != null) {
      Realm tokenRealm = await RealmConnect.getRealm(
        [Token.schema],
        'LoginToken',
      );
      final tokenQuery = tokenRealm
          .query<Token>("_id CONTAINS '${RealmConnect.realmUser.id}'");
      SubscriptionSet tokenSubscriptions = tokenRealm.subscriptions;
      tokenSubscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(tokenQuery, name: "Token", update: true);
      });
      await tokenRealm.subscriptions.waitForSynchronization();

      if (tokenQuery.isEmpty) {
        Token t = Token(RealmConnect.realmUser.id);
        t.token = tokenString;
        tokenRealm.write(() => tokenRealm.add(t));
      } else {
        tokenRealm.write(() => tokenQuery[0].token = tokenString);
      }
      tokenRealm.close();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('EmailPassword',
        <String>[emailController.text, passwordController.text]);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
      (Route<dynamic> route) => false,
    );

    Fluttertoast.showToast(msg: 'Sikeres bejelentkezés.');
  }
}
