import 'package:all_in_fest/pages/chat_page.dart';
import 'package:all_in_fest/pages/swipe_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  var matches = [];
  var photoURLs = [];
  var matchedProfiles = [];
  bool ready = false;

  void loadMatches() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('matches')
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((doc) async {
              matches.add(doc);
            }));
    for (int i = 0; i < matches.length; i++) {
      photoURLs.add(await FirebaseStorage.instanceFor(
              bucket: "gs://festival-2e218.appspot.com")
          .ref()
          .child(matches[i]['user2'] + '.png')
          .getDownloadURL());
    }
    for (int j = 0; j < matches.length; j++) {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(matches[j]['user2'])
          .get();
      matchedProfiles.add(user);
    }
    print(photoURLs[0]);
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
            resizeToAvoidBottomInset: false,
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
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
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
                      matches.length,
                      (index) => Column(
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
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  photoURLs[index].toString()),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle),
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
                                              matchedProfiles[index]['name'],
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
                          )),
                ),
              ),
            )));
  }
}
