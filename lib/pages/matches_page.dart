import 'package:all_in_fest/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  var matches = [];
  bool ready = false;

  @override
  initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users/")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((user) {
      for (String match in user['matches']) {
        matches.add(match);
      }
      getNamesfromUIDs();
    });
  }

  int refreshcount = 0;
  void getNamesfromUIDs() {
    for (int i = 0; i < matches.length; i++) {
      FirebaseFirestore.instance
          .collection("users/")
          .doc(matches[i])
          .get()
          .then((user) {
        matches[i] = matches[i] + " " + user['name'];
        ready = true;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ready) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Matches"),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    matches.length,
                    (index) => ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatPage(),
                              settings: RouteSettings(
                                arguments: matches[index],
                              ),
                            )),
                        child:
                            Text(matches[index].toString().split(" ").last))),
              ),
            ),
          ));
    } else {
      return MaterialApp(
          title: 'Matches',
          home: Scaffold(
              appBar: AppBar(
                title: const Text('Matches'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              )));
    }
  }
}
