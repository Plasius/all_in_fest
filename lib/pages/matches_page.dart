// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/models/user.dart' as user_model;
import 'package:all_in_fest/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import 'menu_sidebar.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  var photos = [];
  var matchQuery;
  var matchedProfiles = <user_model.User>[];
  bool ready = false;
  user_model.User? currentUser;
  var pic;

  void loadMatches() async {
    RealmConnect.realmOpen();
    Configuration matchConfig = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Match.schema]);
    Realm matchesRealm = Realm(matchConfig);
    matchQuery = matchesRealm
        .all<Match>()
        .query("_id CONTAINS '${RealmConnect.app.currentUser.id}'");

    SubscriptionSet subscriptions = matchesRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Matches", update: true);
    });

    await matchesRealm.subscriptions.waitForSynchronization();

    matchQuery = (matchQuery as RealmResults<Match>).toList();
    (matchQuery as List<Match>).sort(
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

    print(matchQuery.length);

    /*  RealmConnect.realmOpen();
    Configuration photoConfig = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [UserImage.schema]);
    Realm imagesRealm = Realm(photoConfig);
    var images = imagesRealm.all<UserImage>();
    print(images.length);
 */
    Configuration userConfig = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user_model.User.schema]);
    Realm userRealm = Realm(userConfig);
    var users = userRealm.all<user_model.User>();

    SubscriptionSet subscriptions2 = userRealm.subscriptions;
    subscriptions2.update((mutableSubscriptions) {
      mutableSubscriptions.add(users, name: "Users", update: true);
    });

    await userRealm.subscriptions.waitForSynchronization();

    print(users.length);

    for (int i = 0; i < matchQuery.length; i++) {
      if (matchQuery[i].user2 == RealmConnect.app.currentUser.id) {
        print("if");
        user_model.User matchedProfile =
            users.query("_id CONTAINS '${matchQuery[i].user1}'")[0];
        matchedProfiles.add(matchedProfile);
        var matchedProfileImage =
            await RealmConnect.realmGetImage(matchedProfile.userID);
        photos.add(matchedProfileImage);
      } else {
        print("else");
        var matchedProfile =
            users.query("_id CONTAINS '${matchQuery[i].user2}'")[0];
        matchedProfiles.add(matchedProfile);
        await RealmConnect.realmGetImage(matchedProfile.userID);
        var matchedProfileImage =
            await RealmConnect.realmGetImage(matchedProfile.userID);
        photos.add(matchedProfileImage);
      }
    }
    print(photos.length);
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadMatches();
    Future.delayed(Duration.zero, () => {loadProfile(), getPic()});
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
            drawer: MenuBar(
                imageProvider: pic ?? const AssetImage("lib/assets/user.png"),
                userName:
                    currentUser != null ? currentUser?.name : "Jelentkezz be!"),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
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
                                            partnerUser: matchedProfiles[index],
                                            match: matchQuery[index],
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
                                          image: photos[index] == null
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      "lib/assets/user.png"),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: photos[index],
                                                  fit: BoxFit.cover),
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
                                                DateFormat('HH:mm').format(DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        matchQuery[index]
                                                                .lastActivity *
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
