// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/user.dart' as user;
import 'package:all_in_fest/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../models/image.dart';
import '../models/realm_connect.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  var photosMap = {};
  var matches = <Match>[];
  var matchedProfiles = <user.User>[];

  late Realm userMatchRealm;
  late Realm imageRealm;

  bool ready = false;
  user.User? currentUser;
  var pic;

  void loadMatches() async {
    Fluttertoast.showToast(
        msg: 'A beszélgetések betöltés alatt.', toastLength: Toast.LENGTH_LONG);

    userMatchRealm = await RealmConnect.getRealm(
        [user.User.schema, Match.schema], 'MatchUser');

    RealmResults<user.User> userQuery = userMatchRealm.all<user.User>();
    RealmResults<Match> matchQuery = userMatchRealm
        .query<Match>("_id CONTAINS '${RealmConnect.realmUser.id}'");

    SubscriptionSet userSub = userMatchRealm.subscriptions;
    userSub.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "MatchUser", update: true);
      mutableSubscriptions.add(matchQuery, name: "MatchMatch", update: true);
    });
    await userMatchRealm.subscriptions.waitForSynchronization();

    //sort the matches based on last activity
    matches = matchQuery.toList();
    matches.sort(
      (a, b) {
        if (a.lastActivity != null && b.lastActivity != null) {
          if (a.lastActivity! < b.lastActivity!) {
            return 1;
          } else {
            return -1;
          }
        }
        return 0;
      },
    );

    print(matches.length);

    //go through matches to find corresponding profile
    for (int i = 0; i < matches.length; i++) {
      //if we are user 2
      if (matches[i].user2 == RealmConnect.realmUser.id) {
        print("if");
        RealmResults<user.User> profiles =
            userQuery.query("_id CONTAINS '${matches[i].user1}'");
        if (profiles.isEmpty == false) {
          matchedProfiles.add(profiles[0]);
          photosMap[matches[i].user1] = null;
        }
      } else {
        //if we are user 1
        print("else");
        RealmResults<user.User> profiles =
            userQuery.query("_id CONTAINS '${matches[i].user2}'");
        if (profiles.isEmpty == false) {
          matchedProfiles.add(profiles[0]);
          photosMap[matches[i].user2] = null;
        }
      }
    }

    setState(() {
      loadImages();
    });
  }

  /*
  void loadImages() async {
    imageRealm = await RealmConnect.getRealm([UserImage.schema], 'MatchImage');
    RealmResults<UserImage> imageQuery = imageRealm.all<UserImage>();
    SubscriptionSet imageSub = imageRealm.subscriptions;
    imageSub.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });
    await imageRealm.subscriptions.waitForSynchronization();

    for (var i = 0; i < matchedProfiles.length; i++) {
      var matchedProfileImage =
          imageQuery.query("user CONTAINS '${matchedProfiles[i].userID}'");
      if (matchedProfileImage.isEmpty == false) {
        photos[i] = MemoryImage(base64Decode(matchedProfileImage[0].data));
      } else {
        photos[i] = null;
      }
    }

    setState(() {});
  }*/

  Future<void> loadImages() async {
    Realm imageRealm =
        await RealmConnect.getRealm([UserImage.schema], 'MatchesImageGet');

    String queryString = '';
    for (var i = 0; i < matchedProfiles.length; i++) {
      if (queryString == '') {
        queryString += "user CONTAINS '${matchedProfiles[i].userID}'";
      } else {
        queryString += " OR user CONTAINS '${matchedProfiles[i].userID}'";
      }
    }

    print(queryString);

    RealmResults<UserImage> imageQuery = imageRealm.query(queryString);

    SubscriptionSet subscriptions = imageRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await imageRealm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      for (UserImage potentialImage in imageQuery) {
        potentialImage = imageQuery[0];
        photosMap[potentialImage.user] =
            MemoryImage(base64Decode(potentialImage.data));
      }
    }

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Welcome to Flutter',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              elevation: 0,
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              /*leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),*/
              title: const Text("Beszélgetések"),
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
                      matchedProfiles.length,
                      (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                            partnerUser: user.User(
                                                matchedProfiles[index].userID,
                                                name: matchedProfiles[index]
                                                    .name),
                                            match: Match(matches[index].matchID,
                                                user1: matches[index].user1,
                                                user2: matches[index].user2,
                                                lastActivity: matches[index]
                                                    .lastActivity),
                                            firstTimeImm: false,
                                          )));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.09,
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
                                          image: photosMap[
                                                      matchedProfiles[index]
                                                          .userID] ==
                                                  null
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      "lib/assets/user.png"),
                                                  fit: BoxFit.fill)
                                              : DecorationImage(
                                                  image: photosMap[
                                                          matchedProfiles[index]
                                                              .userID] ??
                                                      const AssetImage(
                                                          "lib/assets/user.png"),
                                                  fit: BoxFit.fill),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.width * 0.0325,
                                            horizontal: size.width * 0.065),
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
                                                matchedProfiles[index].name ??
                                                    "Partner",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: size.width * 0.01625),
                                              child: Text(
                                                matches.isEmpty
                                                    ? "no time"
                                                    : DateFormat('HH:mm')
                                                        .format(DateTime
                                                            .fromMicrosecondsSinceEpoch(
                                                                matches[index]
                                                                        .lastActivity! *
                                                                    1000)),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
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
