// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/pages/matches_page.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:all_in_fest/models/user.dart' as user;

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  MatchEngine? _matchEngine;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  bool loaded = false;

  //shuffle?

  void getProfiles() async {
    RealmConnect.realmOpen();
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user.User.schema]);
    Realm realm = Realm(config);
    RealmResults<user.User> _profiles = realm.all<user.User>();

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(_profiles, name: "User", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

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
    var ignoreList = [RealmConnect.app.currentUser.id];

    for (int i = 0; i < _matches.length; i++) {
      if (_matches[i].user2 == RealmConnect.app.currentUser.id) {
        ignoreList.add(_matches[i].user1);
      } else {
        ignoreList.add(_matches[i].user2);
      }
    }

    print(_profiles.length);
    for (int i = 0; i < _profiles.length; i++) {
      if (ignoreList.contains(_profiles[i].userID)) continue;

      _swipeItems.add(SwipeItem(
          content: _profiles.length != 0
              ? Container(
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
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("lib/assets/user.png"),
                                    fit: BoxFit.cover))),
                      ),
                      Text(
                        _profiles[i].name ?? 'Jane Doe',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      )
                    ],
                  ))
              : const Text('No profiles found'),
          likeAction: () =>
              {print("${_profiles[i].userID}"), liked(_profiles[i].userID)},
          nopeAction: () => showNopeGif(),
          superlikeAction: () => showHornyGif()));
    }

    _swipeItems.add(SwipeItem(content: Text("")));

    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //getMatches();
    Future.delayed(Duration.zero, () {
      if (loaded == false) {
        getProfiles();
      }

      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loaded == true && _swipeItems.isEmpty == false) {
      return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
            /* drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: 
                    ? MongoDatabase.email!
                    : ""), */ //MongoDatabase.email!),
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
            body: swipeBody()),
      );
    } else {
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
                  image: AssetImage("lib/assets/logo.png"),
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              body: const CircularProgressIndicator()));
    }
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
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MatchesPage())),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  height: MediaQuery.of(context).size.height * 0.067,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(97, 42, 122, 1),
                      border: Border.all(
                          color: const Color.fromRGBO(254, 254, 254, 1),
                          width: 1),
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

  void liked(String otherUser) async {
    print(RealmConnect.app.currentUser.id);
    RealmConnect.realmOpen();
    final _match = Match(RealmConnect.app.currentUser.id + otherUser,
        user1: RealmConnect.app.currentUser.id, user2: otherUser);
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Match.schema]);
    Realm realm = Realm(config);

    final matchQuery = realm.all<Match>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Match", update: true);
    });
    await realm.subscriptions.waitForSynchronization();
    print("synched");

    realm.write(() {
      realm.add(_match);
      print("writed");
    });
  }

  void showNopeGif() {}

  void showHornyGif() {}
}
