import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DateTime selectedDate = DateTime.now();

  var email_1 = TextEditingController();
  var password_1 = TextEditingController();
  var password_2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            /* drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : const AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""), */ //MongoDatabase.email!),
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
                  labelText: 'E-mail megerősítése',
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
            TextFormField(
              controller: password_1,
              decoration: InputDecoration(
                  labelText: 'Új jelszó',
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
                  labelText: 'Új jelszó újra',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Change password'),
                  onPressed: () => jelszoCsere(),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(onPressed: logout, child: const Text("Log out")),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                    onPressed: clearRejected, child: const Text("Swipe reset"))
              ],
            )
          ],
        ),
      ),
    );
  }

  void logout() {
    var appConfig = AppConfiguration("application-0-bjnqv");
    var app = App(appConfig);

    if (app.currentUser != null) app.currentUser?.logOut();
  }

  void jelszoCsere() async {
    if (email_1.text.isEmpty == false &&
        password_1.text == password_2.text &&
        password_1.text.isEmpty == false) {
      var appConfig = AppConfiguration("application-0-bjnqv");
      var app = App(appConfig);

      EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
      await authProvider.callResetPasswordFunction(
          email_1.text, password_1.text,
          functionArgs: []);

      Fluttertoast.showToast(
          msg: "Password reset successfully.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void clearRejected() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('Rejected', <String>[]);
    Fluttertoast.showToast(
        msg: "Mostmár újra várnak a balra húzottaid!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
