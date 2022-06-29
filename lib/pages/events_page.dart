import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorite_model.dart';
import 'favorite_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Stream eventsStream =
      FirebaseFirestore.instance.collection('events').snapshots();

  bool _isFavorite = false;
  void _toggleIconColor() {
    _isFavorite = !_isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    var favoriteEvent = context.watch<FavoriteModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 107, 62, 1),
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Image(
          image: AssetImage("lib/assets/images/logo.png"),
          height: 50,
          fit: BoxFit.contain,
        ),
        actions: [
          Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.favorite_sharp),
            color: Colors.white,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FavoritePage())),
          ),
          Icon(
            Icons.filter_alt_outlined,
            color: Colors.white,
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "/Users/dezsenyigyorgy/Documents/GitHub/all_in_fest/lib/assets/background.png"),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "csütörtök",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "25",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "péntek",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "26",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "szombat",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "27",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "vasárnap",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "28",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
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
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
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
                                                              "Esemény neve",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "színpad",
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
                                                            "9:50-11:20",
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
                                                              "lib/assets/images/event_container.png"),
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
                                                                                const Text(
                                                                                  "Nap",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.normal),
                                                                                ),
                                                                                SizedBox(width: 20),
                                                                                const Text(
                                                                                  "9:50-11:20",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.normal),
                                                                                )
                                                                              ]),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 20, left: 15),
                                                                              child: const Text(
                                                                                "Helyszín",
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
                                                                                  child:
                                                                                      Icon(
                                                                                    favoriteEvent.isFavoriteEvent == true ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                                                                    color: Colors.white,
                                                                                    size: 40,
                                                                                  ),
                                                                                  onTap: () => favoriteEvent.isFavoriteEvent == true
                                                                                      ? {
                                                                                          favoriteEvent.remove(document),
                                                                                          favoriteEvent.changeFavorite(document)
                                                                                        }
                                                                                      : {
                                                                                          favoriteEvent.add(document),
                                                                                          favoriteEvent.changeFavorite(document)
                                                                                        });
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

  Widget eventDetails(var favorite, DocumentSnapshot document) {
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
  }
}
