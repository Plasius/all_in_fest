// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:all_in_fest/models/open_realm.dart';
import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db;
  static var bucket;
  static var currentProfilePic;
  static ImageProvider? picture;

  static disconnect() async {
    db.close();
  }

  static connect() async {
    try {
      db = Db.pool([
        "mongodb://bitclub:Festival22@cluster0-shard-00-00.3v4ig.mongodb.net:27017/allinfest?ssl=true&authSource=admin&retryWrites=true&w=majority",
        "mongodb://bitclub:Festival22@cluster0-shard-00-01.3v4ig.mongodb.net:27017/allinfest?ssl=true&authSource=admin&retryWrites=true&w=majority",
        "mongodb://bitclub:Festival22@cluster0-shard-00-02.3v4ig.mongodb.net:27017/allinfest?ssl=true&authSource=admin&retryWrites=true&w=majority"
      ]);
      await db.open();

      currentProfilePic = RealmConnect.app.currentUser.id != null
          ? await bucket.chunks.findOne(
              where.eq("user", RealmConnect.app.currentUser.id.toString()))
          : null;
      picture = currentProfilePic != null
          ? MemoryImage(base64Decode(currentProfilePic["data"]))
          : null;
    } catch (e) {
      print(e);
    }
  }
}
