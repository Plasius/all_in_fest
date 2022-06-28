import 'package:all_in_fest/models/event_model.dart';
import 'package:all_in_fest/pages/event_details.dart';
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
                                                      builder: (BuildContext
                                                              context) =>
                                                          eventDetails(),
                                                      context: context)),
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

  Widget eventDetails() {
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}
