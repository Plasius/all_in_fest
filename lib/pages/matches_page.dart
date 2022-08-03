// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:all_in_fest/models/match.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/models/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  var matches;
  var photos = [];
  var matchedProfiles = [];
  bool ready = false;

  void loadMatches() async {
    RealmConnect.realmOpen();
    Configuration matchConfig = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Match.schema]);
    Realm matchesRealm = Realm(matchConfig);
    final matchQuery = matchesRealm
        .all<Match>()
        .query("_id CONTAINS '${RealmConnect.app.currentUser.id}'");
    print(matchQuery.length);

    /*  RealmConnect.realmOpen();
    Configuration photoConfig = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [UserImage.schema]);
    Realm imagesRealm = Realm(photoConfig);
    var images = imagesRealm.all<UserImage>();
    print(images.length);
 */
    Configuration userConfig = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user.User.schema]);
    Realm userRealm = Realm(userConfig);
    var users = userRealm.all<user.User>();
    print(users.length);

    for (int i = 0; i < matchQuery.length; i++) {
      if (matchQuery[i].user2 == RealmConnect.app.currentUser.id) {
        print("if");
        var matchedProfile =
            users.query("_id CONTAINS '${matchQuery[i].user1}'")[0];
        matchedProfiles.add(matchedProfile);
        RealmConnect.realmGetImage();
        var matchedProfileImage = RealmConnect.picture;
        photos.add(matchedProfileImage);
      } else {
        print("else");
        var matchedProfile =
            users.query("_id CONTAINS '${matchQuery[i].user2}'")[0];
        matchedProfiles.add(matchedProfile);
        RealmConnect.realmGetImage();
        var matchedProfileImage = RealmConnect.picture;
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
            /* drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : const AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""), */ //MongoDatabase.email!),
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
                      matchedProfiles.length,
                      (index) => GestureDetector(
                            onTap: () {},
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
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "lib/assets/user.png"))),
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
                                                matchedProfiles[index].name,
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
