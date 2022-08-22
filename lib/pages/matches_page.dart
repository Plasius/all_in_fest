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
  var photos = [];
  var matches = <Match>[];
  var matchedProfiles = <user.User>[];

  late Realm matchRealm;
  late Realm userRealm;
  late Realm imageRealm;

  bool ready = false;
  user.User? currentUser;
  var pic;

  void loadMatches() async {
    Fluttertoast.showToast(msg: 'A beszélgetések betöltés alatt.');

    userRealm = await RealmConnect.getRealm([user.User.schema], 'MatchUser');
    RealmResults<user.User> userQuery = userRealm.all<user.User>();
    SubscriptionSet userSub = userRealm.subscriptions;
    userSub.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await userRealm.subscriptions.waitForSynchronization();

    imageRealm = await RealmConnect.getRealm([UserImage.schema], 'MatchImage');
    RealmResults<UserImage> imageQuery = imageRealm.all<UserImage>();
    SubscriptionSet imageSub = imageRealm.subscriptions;
    imageSub.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });
    await imageRealm.subscriptions.waitForSynchronization();

    matchRealm = await RealmConnect.getRealm([Match.schema], 'MatchMatch');
    RealmResults<Match> matchQuery =
        matchRealm.query<Match>("_id CONTAINS '${RealmConnect.realmUser.id}'");
    SubscriptionSet matchSub = matchRealm.subscriptions;
    matchSub.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Match", update: true);
    });
    await matchRealm.subscriptions.waitForSynchronization();

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
        user.User matchedProfile =
            userQuery.query("_id CONTAINS '${matches[i].user1}'")[0];
        matchedProfiles.add(matchedProfile);
        var matchedProfileImage =
            imageQuery.query("user CONTAINS '${matchedProfile.userID}'");
        if (matchedProfileImage.isEmpty == false) {
          photos.add(MemoryImage(base64Decode(matchedProfileImage[0].data)));
        } else {
          photos.add(null);
        }
      } else {
        //if we are user 1
        print("else");
        var matchedProfile =
            userQuery.query("_id CONTAINS '${matches[i].user2}'")[0];
        matchedProfiles.add(matchedProfile);
        var matchedProfileImage =
            imageQuery.query("user CONTAINS '${matchedProfile.userID}'");
        if (matchedProfileImage.isEmpty == false) {
          photos.add(MemoryImage(base64Decode(matchedProfileImage[0].data)));
        } else {
          photos.add(null);
        }
      }
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
                                          image: photos.isEmpty
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      "lib/assets/user.png"),
                                                  fit: BoxFit.fill)
                                              : DecorationImage(
                                                  image: photos[index] ??
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
