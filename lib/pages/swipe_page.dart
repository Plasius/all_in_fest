// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';
import 'dart:math';

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/pages/home_page.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:all_in_fest/models/user.dart' as user_model;

import 'menu_sidebar.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  MatchEngine? _matchEngine;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];

  bool loaded = false;
  var pic;
  user_model.User? currentUser;

  void getProfiles() async {
    RealmConnect.realmOpen();
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user_model.User.schema]);
    Realm realm = Realm(config);
    RealmResults<user_model.User> _profiles = realm.all<user_model.User>();

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(_profiles, name: "User", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    var profileShuffle = _profiles.toList();
    for (int i = 0; i < profileShuffle.length; i++) {
      var a = Random().nextInt(profileShuffle.length);
      var b = Random().nextInt(profileShuffle.length);
      var temp = profileShuffle[a];
      profileShuffle[a] = profileShuffle[b];
      profileShuffle[b] = temp;
    }
    Configuration config2 = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Match.schema]);
    Realm realm2 = Realm(config2);
    RealmResults<Match> _matches = realm2
        .all<Match>()
        .query("_id CONTAINS '${RealmConnect.app.currentUser.id}'");

    SubscriptionSet subscriptions2 = realm2.subscriptions;
    subscriptions2.update((mutableSubscriptions) {
      mutableSubscriptions.add(_matches, name: "Matches", update: true);
    });

    await realm2.subscriptions.waitForSynchronization();

    //szures
    var ignoreList = <String>[RealmConnect.app.currentUser.id];

    for (int i = 0; i < _matches.length; i++) {
      if (_matches[i].user2 == RealmConnect.app.currentUser.id) {
        ignoreList.add(_matches[i].user1.toString());
      } else {
        ignoreList.add(_matches[i].user2.toString());
      }
    }

    //limit to 10

    Map<String, MemoryImage> photosMap =
        await loadImages(profileShuffle, ignoreList);

    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('Rejected');

    int goodProfiles = 0;
    for (int i = 0; i < profileShuffle.length && goodProfiles < 10; i++) {
      if (ignoreList.contains(profileShuffle[i].userID.toString())) continue;

      if (items != null &&
          items.contains(profileShuffle[i].userID.toString())) {
        continue;
      }

      goodProfiles++;

      _swipeItems.add(SwipeItem(
        content: profileShuffle.isNotEmpty
            ? GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(232, 107, 62, 1),
                          Color.fromRGBO(97, 42, 122, 1)
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            profileShuffle[i].name.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                            0.144),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width *
                                        0.664,
                                    height: MediaQuery.of(context).size.height *
                                        0.33,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.78)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: photosMap[profileShuffle[i]
                                                    .userID
                                                    .toString()] ==
                                                null
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    "lib/assets/user.png"),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: photosMap[
                                                    profileShuffle[i]
                                                        .userID
                                                        .toString()]!,
                                              ),
                                      ),
                                    )))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    profileShuffle[i].bio.toString(),
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(97, 42, 122, 1)),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
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
                              image: photosMap[profileShuffle[i]
                                          .userID
                                          .toString()] ==
                                      null
                                  ? const DecorationImage(
                                      image: AssetImage("lib/assets/user.png"),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image: photosMap[
                                          profileShuffle[i].userID.toString()]!,
                                      fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Text(
                          profileShuffle[i].name ?? 'Jane Doe',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ],
                    )),
              )
            : const Text('No profiles found'),
        likeAction: () => {liked(profileShuffle[i].userID)},
        nopeAction: () => showNopeGif(profileShuffle[i].userID),
      ));
    }

    _swipeItems.add(SwipeItem(content: const Text("")));

    loaded = true;
    setState(() {});
  }

  Future<void> getPic() async {
    pic = await RealmConnect.realmGetImage(RealmConnect.app.currentUser.id);
  }

  void loadProfile() async {
    RealmConnect.realmOpen();
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user_model.User.schema]);
    Realm realm = Realm(config);

    var userQuery = realm
        .all<user_model.User>()
        .query("_id CONTAINS '${RealmConnect.app.currentUser.id}'");

    SubscriptionSet userSubscriptions = realm.subscriptions;
    userSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    var user = userQuery[0];
    print(user.name);

    setState(() {
      currentUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    //getMatches();
    Future.delayed(Duration.zero, () {
      loadProfile();
      if (loaded == false) {
        getProfiles();
      }

      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
    getPic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
          drawer: MenuBar(
              imageProvider: pic ?? const AssetImage("lib/assets/user.png"),
              userName:
                  currentUser != null ? currentUser?.name : "Jelentkezz be!"),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
            /*leading: const Icon(
                Icons.menu,
                color: Colors.white,
              ),*/
            title: const Image(
              image: AssetImage("lib/assets/logo.png"),
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          body: swipeBody()),
    );
  }

  Widget swipeBody() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
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
              child: (loaded == true && _swipeItems.isEmpty == false)
                  ? SwipeCards(
                      matchEngine: _matchEngine!,
                      itemBuilder: (BuildContext context, int index) {
                        return _swipeItems[index].content;
                      },
                      onStackFinished: () => showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const Text(
                                    "Sajnos nem találtunk neked profilokat :("),
                                content: const Text(
                                    "Menj, és bulizz egy jót a többiekkel!"),
                                actions: [
                                  CupertinoDialogAction(
                                      child:
                                          const Text("Máris indulok bulizni!"),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()))),
                                  CupertinoDialogAction(
                                    child: const Text("Inkább chatelnék!"),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MatchesPage())),
                                  )
                                ],
                              )),
                    )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  void liked(String otherUser) async {
    RealmConnect.realmOpen();
    final _match = Match(RealmConnect.app.currentUser.id + otherUser,
        user1: RealmConnect.app.currentUser.id,
        user2: otherUser,
        lastActivity: DateTime.now().millisecondsSinceEpoch);
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Match.schema]);
    Realm realm = Realm(config);

    final matchQuery = realm.all<Match>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Match", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    realm.write(() {
      realm.add(_match);
    });

    /* Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MatchesPage())); */
  }

  void showNopeGif(var rejectedID) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('Rejected');

    if (items == null) {
      await prefs.setStringList('Rejected', <String>[rejectedID]);
    } else {
      items.add(rejectedID);
      await prefs.setStringList('Rejected', items);
    }
  }

  void showHornyGif(var bio) {
    if (bio == '') bio = 'Még nincs Bio-m :(';
    Fluttertoast.showToast(
        msg: bio,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  loadImages(
      List<user_model.User> profileShuffle, List<String> ignoreList) async {
    Map<String, MemoryImage> photosMap = {};

    for (user_model.User profile in profileShuffle) {
      if (ignoreList.contains(profile.userID)) continue;

      MemoryImage? potentialImage =
          await RealmConnect.realmGetImage(profile.userID.toString());

      if (potentialImage != null) {
        photosMap[profile.userID.toString()] = potentialImage;
      }
    }

    return photosMap;
  }
}
