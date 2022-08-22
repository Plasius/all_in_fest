// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, library_prefixes, implementation_imports

import 'dart:convert';

import 'package:all_in_fest/models/image.dart';
import 'package:all_in_fest/models/message.dart';
import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/timed_event.dart';
import 'package:all_in_fest/models/token.dart';
import 'package:all_in_fest/models/user.dart' as userData;
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

class RealmConnect {
  static var currentUser = null;
  static var realm = null;
  static bool initialized = false;

  RealmConnect() {
    if (App(AppConfiguration("application-0-bjnqv")).currentUser != null) {
      realm = Realm(Configuration.flexibleSync(
          App(AppConfiguration("application-0-bjnqv")).currentUser!, [
        UserImage.schema,
        Message.schema,
        Match.schema,
        TimedEvent.schema,
        Token.schema,
        userData.User.schema
      ]));

      currentUser = App(AppConfiguration("application-0-bjnqv")).currentUser;

      initialized = true;
    }
  }

  static Future<MemoryImage?> realmGetImage(String userID) async {
    RealmResults<UserImage> imageQuery;
    imageQuery = realm.all<UserImage>().query("user CONTAINS '$userID'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      var currentProfilePic = imageQuery[0];

      return MemoryImage(base64Decode(currentProfilePic.data));
    }

    return null;
  }

  static realmDeleteImage() async {
    RealmResults<UserImage> imageQuery;
    imageQuery = realm
        .all<UserImage>()
        .query("user CONTAINS '${RealmConnect.currentUser.id}'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      realm.write(() => realm.delete(imageQuery[0]));
    }
  }

  static realmLogin(String email, String password) async {}

  static void realmSendMessage(Message _message) async {
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
