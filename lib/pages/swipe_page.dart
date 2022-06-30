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
  List<String> _photoURLs = [];
  /*Future<List<String>> _photoURLs () async {
    List<String> urls = [];
    return urls;
  };*/
  String? photoURL;
  String userID ="";

  void getProfiles() async {
    //final prefs = await SharedPreferences.getInstance();
    //int? counter = prefs.getInt('counter');

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        //.where('name', isNotEqualTo: "Peti")
        //.orderBy('since')
        //.startAfter([counter])
        //.limit(2)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                _profiles.add(doc);
                print(doc.id);
                print('added');
              })
            });

    print(_profiles.length);
    print(_photoURLs.length);

    for (int i = 0; i < _profiles.length; i++) {
      //print(photoURL);
      _swipeItems.add(SwipeItem(
          content: NetworkImage(await FirebaseStorage.instanceFor(bucket: "gs://festival-2e218.appspot.com")
              .ref().child(_profiles[i].id+'.png').getDownloadURL()),
          likeAction: () => messageOptions(),
          nopeAction: () => showNopeGif(),
          superlikeAction: () => showHornyGif()));
    }
    setState(() {});
  }

  void initState() {
    super.initState();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    if (_profiles.length != 0)
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
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 5,
          horizontal: 8.0,
        ),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(97, 42, 122, 1)),
          child: SwipeCards(
            matchEngine: _matchEngine!,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Container(decoration: BoxDecoration(image: DecorationImage(image: _swipeItems[index].content, fit: BoxFit.cover))),
                ),
              );
            },
            onStackFinished: () => showHornyGif(),
          ),
        ),
      ),
    );
  }

  void messageOptions() {}

  void showNopeGif() {}

  void showHornyGif() {}



}
