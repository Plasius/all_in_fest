import 'dart:ffi';

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/message.dart';
import 'package:realm/realm.dart';
import 'package:realm/src/user.dart' as realmUser;
import 'package:all_in_fest/models/user.dart' as user;

class RealmConnect {
  static var realm;
  static var appConfig;
  static var app;
  static var currentUser;

  static void realmOpen() async {
    appConfig = AppConfiguration("application-0-bjnqv");
    app = App(appConfig);
  }

  static void initSchemas() {
    realmOpen();
    Configuration config = Configuration.flexibleSync(
        currentUser, [user.User.schema, Message.schema, Match.schema]);
    realm = Realm(config);
  }

  static void realmRegister(
      String email, String password, user.User _user) async {
    initSchemas();
    EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
    await authProvider.registerUser(email, password);
    realmLogin(email, password);

    final userQuery = realm.all<user.User>();
    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "users", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() {
      realm.add(_user);
    });
  }

  static void realmLogin(String email, String password) async {
    initSchemas();
    Credentials emailPwCredentials = Credentials.emailPassword(email, password);
    currentUser = await app.logIn(emailPwCredentials);
  }

  static void realmSendMessage(Message _message) async {
    initSchemas();
    final messageQuery = realm.all<Message>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "messages", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() {
      realm.add(_message);
    });
  }

  static void realmAddMatch(Match _match) async {
    initSchemas();
    final matchQuery = realm.all<Match>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "messages", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() {
      realm.add(_match);
    });
  }
}
