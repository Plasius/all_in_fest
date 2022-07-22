import 'dart:convert';

import 'package:all_in_fest/models/mongo_connect.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'menu_sidebar.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _matches = [];

  void getProfiles() async {
    _profiles = await MongoDatabase.users
        .find(mongo.where.ne('userID', FirebaseAuth.instance.currentUser?.uid))
        .toList();
    print(_profiles.length);
    for (int i = 0; i < _profiles.length; i++) {
      var img = await MongoDatabase.bucket.chunks
          .findOne(mongo.where.eq('user', _profiles[i]["userID"]));
      _swipeItems.add(SwipeItem(
          content: _profiles.isNotEmpty
              ? Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(97, 42, 122, 1)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "in/Touch",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, top: 10, bottom: 10),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        MemoryImage(base64Decode(img["data"])),
                                    fit: BoxFit.cover))),
                      ),
                      Text(
                        _profiles[i]['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      )
                    ],
                  ))
              : Text('No profiles found'),
          likeAction: () => messageOptions(_profiles[i]["userID"]),
          nopeAction: () => showNopeGif(),
          superlikeAction: () => showHornyGif()));
    }
    setState(() {});
  }

  void getMatches() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await MongoDatabase.matches
        .find(mongo.where.within('_id', auth.currentUser?.uid));
  }

  void initState() {
    super.initState();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    //getMatches();
    getProfiles();
    getMatches();
  }

  @override
  Widget build(BuildContext context) {
    if (_profiles.isNotEmpty) {
      return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
            drawer: MenuBar(
                imageProvider: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.picture!
                    : AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""), //MongoDatabase.email!),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              leading: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: const Image(
                image: const AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            body: swipeBody()),
      );
    } else
      return MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
                leading: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                title: const Image(
                  image: const AssetImage("lib/assets/logo.png"),
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              body: CircularProgressIndicator()));
  }

  Widget swipeBody() {
    var size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/LOGIN.png"), fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 5,
            left: 8.0,
            right: 8,
            bottom: MediaQuery.of(context).size.height / 25),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: SwipeCards(
                matchEngine: _matchEngine!,
                itemBuilder: (BuildContext context, int index) {
                  return _swipeItems[index].content
                      /*Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: _swipeItems[index].content,
                                  fit: BoxFit.cover))),
                    ),
                  )*/
                      ;
                },
                onStackFinished: () => showHornyGif(),
                upSwipeAllowed: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MatchesPage())),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  height: MediaQuery.of(context).size.height * 0.067,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(97, 42, 122, 1),
                      border: Border.all(
                          color: Color.fromRGBO(254, 254, 254, 1), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30),
                    child: Image.asset("lib/assets/chat_icon.png"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void messageOptions(String otherUser) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await MongoDatabase.matches.insertOne({
      "_id": "${auth.currentUser?.uid}" + otherUser,
      "user1": auth.currentUser?.uid,
      "user2": otherUser
    });
  }

  void showNopeGif() {}

  void showHornyGif() {}
}
