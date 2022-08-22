// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, library_prefixes, implementation_imports

import 'dart:convert';
import 'dart:io';

import 'package:all_in_fest/models/image.dart';
import 'package:all_in_fest/models/message.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

class RealmConnect {
  static late User realmUser;

  static Future<Realm> getRealm(
      List<SchemaObject> list, String realmName) async {
    return Realm(Configuration.flexibleSync(realmUser, list,
        path: await absolutePath(
            "db_${DateTime.now().millisecondsSinceEpoch.toString()}.realm"),
        syncErrorHandler: (p0) => {},
        syncClientResetErrorHandler:
            SyncClientResetErrorHandler(((code) => {}))));
  }

  static Future<MemoryImage?> realmGetImage(String userID) async {
    Realm imageRealm = await getRealm([UserImage.schema], 'RealmImageGet');
    RealmResults<UserImage> imageQuery;
    imageQuery = imageRealm.all<UserImage>().query("user CONTAINS '$userID'");

    SubscriptionSet subscriptions = imageRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await imageRealm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      var currentProfilePic = imageQuery[0];
      return MemoryImage(base64Decode(currentProfilePic.data));
    }
    return null;
  }

  static realmDeleteImage() async {
    Realm imageRealm = await getRealm([UserImage.schema], 'RealmImage');
    RealmResults<UserImage> imageQuery;
    imageQuery = imageRealm
        .all<UserImage>()
        .query("user CONTAINS '${RealmConnect.realmUser.id}'");

    SubscriptionSet subscriptions = imageRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await imageRealm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      imageRealm.write(() => imageRealm.delete(imageQuery[0]));
    }

    imageRealm.close();
  }

  static realmLogin(String email, String password) async {}

  static void realmSendMessage(Message _message) async {
    Realm messageRealm =
        await RealmConnect.getRealm([Message.schema], 'RealmMessageSend');
    final messageQuery = messageRealm.all<Message>();
    SubscriptionSet messageSubscriptions = messageRealm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    await messageRealm.subscriptions.waitForSynchronization();

    messageRealm.write(() {
      messageRealm.add(_message);
    });

    messageRealm.close();
  }

  static Future<String> absolutePath(String fileName) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final realmDirectory = '${appDocsDirectory.path}/mongodb-realm';
    if (!Directory(realmDirectory).existsSync()) {
      await Directory(realmDirectory).create(recursive: true);
    }
    return "$realmDirectory/$fileName";
  }
}
