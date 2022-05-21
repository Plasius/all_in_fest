import 'package:all_in_fest/pages/chat_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';
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
        matches[i] = matches[i] + " " + user['name'] + " " + user['photo'];
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
          body: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    matches.length,
                    (index) => ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatPage(),
                              settings: RouteSettings(
                                arguments: matches[index],
                              ),
                            )),
                        title: Row(children: [
                          /*Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            image: NetworkImage(
                                matches[index].toString().split(" ")[2]),
                          )),*/
                          Text(matches[index].toString().split(" ")[1],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ])),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SwipePage())),
                    child: const Text("Swipe page",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey))),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: null,
                  child: const Text("Matches page",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                )
              ]),
            )
          ]));
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
