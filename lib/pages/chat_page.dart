// ignore_for_file: library_prefixes, implementation_imports, prefer_typing_uninitialized_variables, avoid_print

// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:all_in_fest/models/message.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/models/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../models/image.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.partnerUser}) : super(key: key);

  final user.User partnerUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var partnerImage;
  var partnerName;

  var messages = <Message>[];

  //initializes partnerImage and partnerName
  loadPartnerNameAndImage() async {
    RealmResults<UserImage> imageQuery;
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [UserImage.schema]);
    Realm realm = Realm(config);
    imageQuery = realm
        .all<UserImage>()
        .query("user CONTAINS '${widget.partnerUser.userID}'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      var picdata = imageQuery[0];
      partnerImage = MemoryImage(base64Decode(picdata.data));
    }

    partnerName = widget.partnerUser.name;
    setState(() {});
  }

  //initializes messages
  loadMessages() async {
    RealmResults<Message> messageQuery;
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [UserImage.schema]);
    Realm realm = Realm(config);
    messageQuery = realm.all<Message>().query(
        "matchID CONTAINS '${widget.partnerUser.userID}' AND matchID CONTAINS '${RealmConnect.currentUser.id.toString()}'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    messages = messageQuery.toList();

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadPartnerNameAndImage();
    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat page',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              title: const Image(
                image: AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            body: CircularProgressIndicator()));
  }
}
