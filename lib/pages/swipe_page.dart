import 'package:all_in_fest/pages/matches_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  MatchEngine? _matchEngine;
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  List<DocumentSnapshot> _profiles = [];
  List<DocumentSnapshot> _unneccessaryProfiles = [];
  List<DocumentSnapshot> _matches = [];

  void getProfiles() async {
    //final prefs = await SharedPreferences.getInstance();
    //int? counter = prefs.getInt('counter');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    await firebaseFirestore
        .collection('users')
        .where('userID', isNotEqualTo: auth.currentUser?.uid)
        //.orderBy('since')
        //.startAfter([counter])
        //.limit(2)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                if(_matches.isNotEmpty){
                  for(int i=0; i<_matches.length; i++){
                    if(doc.id==_matches[i]['user2']){
                      _unneccessaryProfiles.add(doc);
                    }
                    else{
                      doc['photo'] != ""
                          ? _profiles.add(doc)
                          : _unneccessaryProfiles.add(doc);
                    }
                  }
                }
                else{
                  doc['photo'] != ""
                      ? _profiles.add(doc)
                      : _unneccessaryProfiles.add(doc);
                }
              })
            });

    print(_profiles.length);
    print(_matches.length);

    for (int i = 0; i < _profiles.length; i++) {
      //print(_profiles[i]['photo']);
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
                                    image: NetworkImage(
                                        await FirebaseStorage.instanceFor(
                                                bucket:
                                                    "gs://festival-2e218.appspot.com")
                                            .ref()
                                            .child(_profiles[i].id + '.png')
                                            .getDownloadURL()),
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
          likeAction: () => messageOptions(_profiles[i].id),
          nopeAction: () => showNopeGif(),
          superlikeAction: () => showHornyGif()));
    }
    setState(() {});
  }

  void getMatches() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('matches')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                _matches.add(doc);
              })
            });
    //setState(() {});
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
    if (_profiles.isNotEmpty)
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
            body: swipeBody()),
      );
    else
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
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('matches')
        .doc(auth.currentUser!.uid.toString() + otherUser)
        .set({
      'user1': auth.currentUser?.uid,
      'user2': otherUser,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });

    await firebaseFirestore
        .collection('users')
        .doc(otherUser)
        .collection('matches')
        .doc(otherUser + auth.currentUser!.uid.toString())
        .set({
      'user1': otherUser,
      'user2': auth.currentUser?.uid,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
    });
  }

  void showNopeGif() {}

  void showHornyGif() {}
}
