// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, library_prefixes, implementation_imports

import 'dart:convert';

import 'package:all_in_fest/models/image.dart';
import 'package:all_in_fest/models/message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';
import 'package:realm/src/user.dart' as realmUser;
import 'package:all_in_fest/models/user.dart' as user;

class RealmConnect {
  static var appConfig;
  static var app;
  static var currentUser;
  static var currentProfilePic;

  static void realmOpen() async {
    appConfig = AppConfiguration("application-0-bjnqv");
    app = App(appConfig);
  }

  static Future<MemoryImage?> realmGetImage(String userID) async {
    realmOpen();
    RealmResults<UserImage> imageQuery;
    Configuration config =
        Configuration.flexibleSync(app.currentUser, [UserImage.schema]);
    Realm realm = Realm(config);
    imageQuery = realm.all<UserImage>().query("user CONTAINS '$userID'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      currentProfilePic = imageQuery[0];
      return MemoryImage(base64Decode(currentProfilePic.data));
    }
    return null;
  }

  static realmDeleteImage() async {
    realmOpen();
    RealmResults<UserImage> imageQuery;
    Configuration config =
        Configuration.flexibleSync(app.currentUser, [UserImage.schema]);
    Realm realm = Realm(config);
    imageQuery = realm
        .all<UserImage>()
        .query("user CONTAINS '${RealmConnect.app.currentUser.id}'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      realm.write(() => realm.delete(imageQuery[0]));
    }
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

  static realmLogin(String email, String password) async {
    realmOpen();
    Credentials emailPwCredentials = Credentials.emailPassword(email, password);
    try {
      currentUser = await app.logIn(emailPwCredentials);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Nem sikerült bejelentkezni.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
}
