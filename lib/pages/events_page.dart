import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorite_model.dart';
import '../models/mongo_connect.dart';
import 'favorite_page.dart';
import 'menu_sidebar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Stream eventsStream =
      FirebaseFirestore.instance.collection('events').snapshots();
  String _selectedStage = "";
  String _selectedDate = "";
  List<Text> stages = [
    const Text("1. stage"),
    const Text("2. stage"),
    const Text("3. stage"),
    const Text("4. stage"),
    const Text("5. stage"),
  ];

/*
  void addEvents() async {
    int stageNumber;
    for (int i = 0; i < 51; i++) {
      stageNumber = i % 5 + 1;
      await FirebaseFirestore.instance
          .collection('events')
          .doc('event' + i.toString())
          .set({
        'id': i,
        'bio': "",
        'name': "event" + i.toString(),
        'datetime': stageNumber == 1
            ? "augusztus 25."
            : stageNumber == 2
                ? "augusztus 26."
                : stageNumber == 3
                    ? "augusztus 27."
                    : stageNumber == 4
                        ? "augusztus 28."
                        : stageNumber == 5 ? "augusztus 25." : "",
        'photo': "",
        'stage': stageNumber.toString() + ". " + "stage"
      });
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    var favoriteEvent = context.read<FavoriteModel>();
    return Scaffold(
      drawer: MenuBar(
          imageProvider: MongoDatabase.picture != null
              ? MongoDatabase.picture!
              : AssetImage("lib/assets/user.png"),
          userName: FirebaseAuth.instance.currentUser != null
              ? MongoDatabase.currentUser["name"]
              : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
          email: FirebaseAuth.instance.currentUser != null
              ? MongoDatabase.email!
              : ""), //MongoDatabase.email!),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 107, 62, 1),
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Image(
          image: AssetImage("lib/assets/logo.png"),
          height: 50,
          fit: BoxFit.contain,
        ),
        actions: [
/*
          IconButton(
            icon: Icon(Icons.add_rounded),
            color: Colors.white,
            onPressed: () {
              addEvents();
            },
          ),
*/
          IconButton(
            icon: Icon(Icons.favorite_sharp),
            color: Colors.white,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FavoritePage())),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            color: Colors.white,
            onPressed: () {
              showFilter();
            },
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/assets/background.png"),
                fit: BoxFit.cover)),
        child: Column(children: [
          Container(
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                color: Color.fromRGBO(232, 107, 62, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate == "augusztus 25."
                          ? _selectedDate = ""
                          : _selectedDate = "augusztus 25.";
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "csütörtök",
                          style: TextStyle(
                              color: _selectedDate == "augusztus 25."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: _selectedDate == "augusztus 25."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "25",
                              style: TextStyle(
                                  color: _selectedDate == "augusztus 25."
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate == "augusztus 26."
                          ? _selectedDate = ""
                          : _selectedDate = "augusztus 26.";
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "péntek",
                          style: TextStyle(
                              color: _selectedDate == "augusztus 26."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: _selectedDate == "augusztus 26."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "26",
                              style: TextStyle(
                                  color: _selectedDate == "augusztus 26."
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate == "augusztus 27."
                          ? _selectedDate = ""
                          : _selectedDate = "augusztus 27.";
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "szombat",
                          style: TextStyle(
                              color: _selectedDate == "augusztus 27."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: _selectedDate == "augusztus 27."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "27",
                              style: TextStyle(
                                  color: _selectedDate == "augusztus 27."
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate == "augusztus 28."
                          ? _selectedDate = ""
                          : _selectedDate = "augusztus 28.";
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "vasárnap",
                          style: TextStyle(
                              color: _selectedDate == "augusztus 28."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: _selectedDate == "augusztus 28."
                                  ? Color.fromRGBO(97, 42, 122, 1)
                                  : Colors.white,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "28",
                              style: TextStyle(
                                  color: _selectedDate == "augusztus 28."
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('events').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs
                        .where((element) => element
                            .get('stage')
                            .toString()
                            .contains(_selectedStage))
                        .where((element) => element
                            .get('datetime')
                            .toString()
                            .contains(_selectedDate))
                        .map((DocumentSnapshot document) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                1,
                                (index) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 10,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            12,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        254,
                                                                        192,
                                                                        1,
                                                                        1)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              document['name'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              document['stage'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            document[
                                                                'datetime'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .favorite_border_sharp),
                                                            color: Colors.white,
                                                            onPressed: () {
                                                              favoriteEvent.add(
                                                                  document);
                                                            },
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "lib/assets/event_container.png"),
                                                          fit:
                                                              BoxFit.contain))),
                                              onTap: () =>
                                                  showCupertinoModalPopup(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.74,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      Color.fromRGBO(
                                                                          232,
                                                                          107,
                                                                          62,
                                                                          1),
                                                                      Color.fromRGBO(
                                                                          97,
                                                                          42,
                                                                          122,
                                                                          1)
                                                                    ],
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(15.0),
                                                                              child: Text(
                                                                                document['name'],
                                                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 10, left: 15),
                                                                              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                Text(
                                                                                  document['datetime'],
                                                                                  style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.normal),
                                                                                ),
                                                                                SizedBox(width: 20),
                                                                                Text(
                                                                                  document['datetime'],
                                                                                  style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.normal),
                                                                                )
                                                                              ]),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 20, left: 15),
                                                                              child: Text(
                                                                                document['stage'],
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16.5),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 35.0),
                                                                            child: Consumer<FavoriteModel>(builder: (context, favoriteEvent, child) {
                                                                              return GestureDetector(
                                                                                  child: Icon(
                                                                                    favoriteEvent.checkFavorite(document) == true ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                                                                    color: Colors.white,
                                                                                    size: 40,
                                                                                  ),
                                                                                  onTap: () => favoriteEvent.checkFavorite(document) == true ? favoriteEvent.remove(document) : favoriteEvent.add(document));
                                                                            }))
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))),
                                        ],
                                      ),
                                    )),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ]),
      ),
    );
  }

  void showFilter() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.25,
              color: Colors.white,
              child: CupertinoPicker(
                children: stages,
                onSelectedItemChanged: (value) {
                  Text text = stages[value];
                  setState(() {
                    _selectedStage = text.data.toString();
                  });
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: false,
              ));
        });
  }

  /*Widget eventDetails(var favorite, DocumentSnapshot document) {
    favorite = context.watch<FavoriteModel>();
    return CupertinoPopupSurface(
        isSurfacePainted: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.74,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text(
                          "Fellépő neve",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Nap",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(width: 20),
                              const Text(
                                "9:50-11:20",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.normal),
                              )
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 15),
                        child: const Text(
                          "Helyszín",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.5),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: GestureDetector(
                        child: Icon(
                          _isFavorite == true
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Colors.white,
                          size: 40,
                        ),
                        onTap: () => _toggleIconColor()),
                  )
                ],
              ),
            ],
          ),
        ));
  }*/
}
