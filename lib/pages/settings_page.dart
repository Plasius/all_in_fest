import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/realm_connect.dart';
import 'package:all_in_fest/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_in_fest/models/user.dart' as user_model;
import 'package:http/http.dart' as http;

import '../models/image.dart';
import '../models/message.dart';

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

  user_model.User? currentUser;
  // ignore: prefer_typing_uninitialized_variables
  var pic;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => loadProfile());
    getPic();
  }

  Future<void> getPic() async {
    pic = await RealmConnect.realmGetImage(RealmConnect.currentUser.id);
  }

  void loadProfile() async {
    Configuration config = Configuration.flexibleSync(
        RealmConnect.currentUser, [user_model.User.schema]);
    Realm realm = Realm(config);

    var userQuery = realm
        .all<user_model.User>()
        .query("_id CONTAINS '${RealmConnect.currentUser.id}'");

    SubscriptionSet userSubscriptions = realm.subscriptions;
    userSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    var user = userQuery[0];

    if (mounted == true) {
      setState(() {
        currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              /*leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),*/
              title: const Image(
                image: AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            body: editBody()));
  }

  Widget editBody() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/background.png"),
              fit: BoxFit.cover)),
      child: SingleChildScrollView(
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
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
                    labelText: 'E-mail megerősítése',
                    labelStyle: const TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    hintText: 'radev.anthony@uni-corvinus.hu',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.3),
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: password_1,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
                      labelText: 'Új jelszó',
                      labelStyle: const TextStyle(
                          color: Colors.purple,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      hintText: 'wellbe#top100',
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.3),
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.purple)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.purple)))),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: password_2,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
                    labelText: 'Új jelszó újra',
                    labelStyle: const TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    hintText: 'wellbe#top100',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.3),
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.purple))),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                    child: const Text('Jelszó cseréje'),
                    onPressed: () => jelszoCsere(),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                      onPressed: logout,
                      child: const Text("Kijelentkezés")),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                      onPressed: clearRejected,
                      child: const Text("Balra húzottak visszaállítása")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                      onPressed: () => showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const Text(
                                  "Biztosan törölnéd fiókod?",
                                ),
                                content: const Text(
                                    "Profil, üzenetek, adatok mind törlödni fognak."),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Igen",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () => {
                                      deleteUser(),
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text("Mégsem"),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              )),
                      child: const Text("Fiók törlése"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void logout() {
    if (RealmConnect.currentUser != null) {
      RealmConnect.currentUser?.logOut();
      RealmConnect.currentUser = null;
      RealmConnect.realm.close();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void jelszoCsere() async {
    if (email_1.text.isEmpty == false &&
        password_1.text == password_2.text &&
        password_1.text.isEmpty == false) {
      var app = App(AppConfiguration('application-0-bjnqv'));

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

  Future<void> deleteUser() async {
    Configuration userConfig = Configuration.flexibleSync(
        RealmConnect.currentUser, [user_model.User.schema]);
    Realm userRealm = Realm(userConfig);
    var userQuery = userRealm
        .all<user_model.User>()
        .query("_id CONTAINS '${RealmConnect.currentUser.id}'");
    SubscriptionSet userSubscriptions = userRealm.subscriptions;
    userSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    //delete user data objeck
    await userRealm.subscriptions.waitForSynchronization();

    RealmResults<UserImage> imageQuery;
    Configuration imageConfig = Configuration.flexibleSync(
        RealmConnect.currentUser, [UserImage.schema]);
    Realm imageRealm = Realm(imageConfig);
    imageQuery = imageRealm
        .all<UserImage>()
        .query("user CONTAINS '${RealmConnect.currentUser.id}'");
    SubscriptionSet imageSubscriptions = imageRealm.subscriptions;
    imageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });
    //delete user image
    await imageRealm.subscriptions.waitForSynchronization();

    RealmResults<Message> messageQuery;
    Configuration messageConfig =
        Configuration.flexibleSync(RealmConnect.currentUser, [Message.schema]);
    Realm messageRealm = Realm(messageConfig);
    messageQuery = messageRealm
        .all<Message>()
        .query("matchID CONTAINS '${RealmConnect.currentUser?.id.toString()}'");
    SubscriptionSet messageSubscriptions = messageRealm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    //delete user messages
    await messageRealm.subscriptions.waitForSynchronization();

    RealmResults<Match> matchQuery;
    Configuration matchConfig =
        Configuration.flexibleSync(RealmConnect.currentUser, [Match.schema]);
    Realm matchesRealm = Realm(matchConfig);
    matchQuery = matchesRealm
        .all<Match>()
        .query("_id CONTAINS '${RealmConnect.currentUser.id}'");
    SubscriptionSet matchSubscription = matchesRealm.subscriptions;
    matchSubscription.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Match", update: true);
    });
    //delete user matches
    await matchesRealm.subscriptions.waitForSynchronization();

    if (userQuery.isEmpty == false) {
      userRealm.write(() => {userRealm.deleteMany(userQuery)});
    }

    if (imageQuery.isEmpty == false) {
      imageRealm.write(() => {imageRealm.deleteMany(imageQuery)});
    }

    if (messageQuery.isEmpty == false) {
      messageRealm.write(() => {messageRealm.deleteMany(messageQuery)});
    }

    if (matchQuery.isEmpty == false) {
      matchesRealm.write(() => {matchesRealm.deleteMany(matchQuery)});
    }

    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getStringList('EmailPassword')![0],
        pass = prefs.getStringList('EmailPassword')![1];

    await http.delete(
      Uri.parse(
          'https://eu-central-1.aws.data.mongodb-api.com/app/application-0-bjnqv/endpoint/deleteuser'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'email': email,
        'password': pass,
      },
    );

    RealmConnect.currentUser = null;

    Fluttertoast.showToast(msg: "Fiókod töröltük.");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
