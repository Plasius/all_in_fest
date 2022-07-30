// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:all_in_fest/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../models/mongo_connect.dart';
import 'menu_sidebar.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  var matches = [];
  var photoURLs = [];
  var matchedProfiles = [];
  bool ready = false;

  void loadMatches() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    matches = await MongoDatabase.matches
        .find(mongo.where.match('_id', "${auth.currentUser?.uid}"))
        .toList();
    for (var element in matches) {
      print(FirebaseAuth.instance.currentUser?.uid);
      print(element["user1"]);
      print(element["user2"]);
      var partner;
      element["user2"] == FirebaseAuth.instance.currentUser?.uid
          ? partner = element["user1"]
          : partner = element["user2"];
      print(partner);
      var matchedProfile =
          await MongoDatabase.users.findOne(mongo.where.eq("userID", partner));
      print(matchedProfile["name"]);
      matchedProfiles.add(matchedProfile);
      print(matchedProfiles.length);

      var partnerPhoto = await MongoDatabase.bucket.chunks
          .findOne(mongo.where.eq("user", partner));
      photoURLs.add(partnerPhoto != null
          ? MemoryImage(base64Decode(partnerPhoto["data"]))
          : const AssetImage("lib/assets/user.png"));
      print(photoURLs.length);
    }
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadMatches();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
            drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : const AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""), //MongoDatabase.email!),
            resizeToAvoidBottomInset: false,
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
            body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(232, 107, 62, 1),
                    Color.fromRGBO(97, 42, 122, 1)
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      matches.length,
                      (index) => GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          chatPartnerID: matches[index]
                                                      ["user2"] ==
                                                  FirebaseAuth
                                                      .instance.currentUser?.uid
                                              ? matches[index]["user1"]
                                              : matches[index]["user2"],
                                          photo: photoURLs[index],
                                          chatPartnerName:
                                              matchedProfiles[index]["name"],
                                        ))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.065,
                                      right: size.width * 0.065,
                                      top: size.width * 0.065,
                                      bottom: size.width * 0.01625),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.height * 0.11,
                                        width: size.width * 0.24,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: photoURLs[index])),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.0325),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: size.width * 0.01625),
                                              child: Text(
                                                matchedProfiles[index]["name"],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            const Text(
                                              "Üzenet",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                  indent: size.width * 0.077,
                                  endIndent: size.width * 0.077,
                                  thickness: size.height * 0.0011,
                                )
                              ],
                            ),
                          )),
                ),
              ),
            )));
  }
}
