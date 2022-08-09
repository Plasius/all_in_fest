// ignore_for_file: library_prefixes, implementation_imports, avoid_print

import 'package:all_in_fest/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:realm/realm.dart';
import 'package:realm/src/user.dart' as realmUser;
import 'package:all_in_fest/models/user.dart' as user;
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  var nameController = TextEditingController();
  bool checkedValue = false;

  bool _showPassword = false;
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
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/LOGIN.png"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            reverse: true,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.019,
                    right: MediaQuery.of(context).size.width * 0.019,
                    top: MediaQuery.of(context).size.height * 0.033,
                    bottom: MediaQuery.of(context).size.height * 0.033),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(97, 42, 122, 1),
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
                                top: MediaQuery.of(context).size.height * 0.027,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.022),
                            child: const Center(
                              child: Text(
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
                                left: MediaQuery.of(context).size.width * 0.043,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.011),
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
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
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
                                bottom: size.width * 0.041),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
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
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.043,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.011),
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
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.4),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                  controller: passwordConfirmController,
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
                          CheckboxListTile(
                            title: InkWell(
                                child: const Text('Elfogadod az ÁSZF-et?'),
                                onTap: () => launchUrl(Uri.parse(
                                    'https://ybg.hu/wp-content/uploads/2022/01/Adatkezelesi-es-adatvedelmi-szabalyzat.pdf'))),
                            value: checkedValue,
                            onChanged: (newValue) {
                              setState(() {
                                checkedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.white,
                            checkColor: Colors.orange,
                            side: const BorderSide(
                                color: Colors.white,
                                width: 3), //  <-- leading Checkbox
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () => createUserProfile(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(254, 192, 1, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.009,
                                      horizontal: size.width * 0.065),
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.04,
                                right: size.height * 0.022,
                                bottom: size.height * 0.04),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: size.height * 0.013),
                                      child: const Text("Már van fiókod?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage())),
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

  //FirebaseAuth auth = FirebaseAuth.instance;

  void createUserProfile() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty ||
        checkedValue == false) {
      print("Please fill out all of the fields.");
      return;
    }

    if (passwordConfirmController.text != passwordController.text) {
      print("Passwords don't match.");
      return;
    }

    AppConfiguration appConfig = AppConfiguration("application-0-bjnqv");
    App app = App(appConfig);
    EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
    await authProvider.registerUser(
        emailController.text, passwordController.text);
    Credentials emailPwCredentials = Credentials.emailPassword(
        emailController.text, passwordController.text);
    realmUser.User currentUser = await app.logIn(emailPwCredentials);

    final _user = user.User(currentUser.id,
        name: nameController.text,
        bio: "Allways all in",
        since: DateTime.now().millisecondsSinceEpoch);

    Configuration config =
        Configuration.flexibleSync(currentUser, [user.User.schema]);
    Realm realm = Realm(config);

    final userQuery = realm.all<user.User>();
    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() => {realm.add(_user)});
    Navigator.pop(context);

    /*try {
      MongoDatabase.users.insertOne({
        'name': name,
        'bio': "Always all in.",
        'since': DateTime.now().millisecondsSinceEpoch,
        'userID': auth.currentUser?.uid
      });
    } catch (e) {
      print(e.runtimeType);
    }*/

    final prefs = await SharedPreferences.getInstance();

    final int? counter = prefs.getInt('counter');
    if (counter == null) {
      await prefs.setInt('counter', 0);
    }
  }
}
