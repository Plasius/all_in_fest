import 'package:all_in_fest/pages/matches_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void getProfiles() async {
    //final prefs = await SharedPreferences.getInstance();

    //int? counter = prefs.getInt('counter');

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        //.orderBy('since')
        //.startAfter([counter])
        //.limit(2)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              print('running' + querySnapshot.docs[0].toString()),
              querySnapshot.docs.forEach((doc) {
                _profiles.add(doc);
                print('added');
              })
            });

    print(_profiles.length);

    for (int i = 0; i < _profiles.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Text(_profiles[i]['photo']),
          likeAction: () => messageOptions(),
          nopeAction: () => showNopeGif(),
          superlikeAction: () => showHornyGif()));
    }

    setState(() {});
  }

  void initState() {
    super.initState();
    _matchEngine = new MatchEngine(swipeItems: _swipeItems);
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
                image: const AssetImage("lib/assets/images/logo.png"),
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
                  image: const AssetImage("lib/assets/images/logo.png"),
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              body: CircularProgressIndicator()));
  }

  Widget swipeBody() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height,
        child: SwipeCards(
          matchEngine: _matchEngine!,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(child: _swipeItems[index].content),
            );
          },
          onStackFinished: () => showHornyGif(),
        ),
      ),
    );
  }

  void messageOptions() {}

  void showNopeGif() {}

  void showHornyGif() {}
}
