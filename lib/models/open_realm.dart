// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, library_prefixes, implementation_imports

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/message.dart';
import 'package:realm/realm.dart';
import 'package:realm/src/user.dart' as realmUser;
import 'package:all_in_fest/models/user.dart' as user;

class RealmConnect {
  static var appConfig;
  static var app;
  static var currentUser;

  static void realmOpen() async {
    appConfig = AppConfiguration("application-0-bjnqv");
    app = App(appConfig);
  }

  static void realmRegister(
      String email, String password, user.User _user) async {
    AppConfiguration appConfig = AppConfiguration("application-0-bjnqv");
    App app = App(appConfig);
    EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
    await authProvider.registerUser(email, password);
    Credentials emailPwCredentials = Credentials.emailPassword(email, password);
    realmUser.User currentUser = await app.logIn(emailPwCredentials);

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
  }

  static void realmLogin(String email, String password) async {
    realmOpen();
    Credentials emailPwCredentials = Credentials.emailPassword(email, password);
    currentUser = await app.logIn(emailPwCredentials);
  }

  static void realmSendMessage(Message _message) async {
    Configuration config =
        Configuration.flexibleSync(app.currentUser, [Message.schema]);
    Realm realm = Realm(config);
    final messageQuery = realm.all<Message>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() {
      realm.add(_message);
    });
  }

  static void realmAddMatch(Match _match) async {
    Configuration config =
        Configuration.flexibleSync(app.currentUser, [Match.schema]);
    Realm realm = Realm(config);

    final matchQuery = realm.all<Match>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Match", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() {
      realm.add(_match);
      print("writed");
    });
  }
}
