import 'dart:io';

import 'package:all_in_fest/models/favorite_model.dart';
import 'package:all_in_fest/pages/events_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mongo_connect.dart';
import 'menu_sidebar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String _selectedStage = "";
  String _selectedDate = "";
  List<Text> stages = [
    const Text("1. stage"),
    const Text("2. stage"),
    const Text("3. stage"),
    const Text("4. stage"),
    const Text("5. stage"),
  ];

  @override
  Widget build(BuildContext context) {
    var favoriteEvent = context.watch<FavoriteModel>();
    return Scaffold(
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
        actions: [
          const Icon(
            Icons.search_outlined,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EventsPage())),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            color: Colors.white,
            onPressed: () {
              showFilter();
              favoriteEvent.filterEvents(_selectedDate, _selectedStage);
            },
          )
        ],
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/background.png"),
                  fit: BoxFit.cover)),
          child: Column(children: [
            Container(
                height: MediaQuery.of(context).size.height / 8,
                decoration: const BoxDecoration(
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
                                    ? const Color.fromRGBO(97, 42, 122, 1)
                                    : Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: _selectedDate == "augusztus 25."
                                    ? const Color.fromRGBO(97, 42, 122, 1)
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
                                    ? const Color.fromRGBO(97, 42, 122, 1)
                                    : Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: _selectedDate == "augusztus 26."
                                    ? const Color.fromRGBO(97, 42, 122, 1)
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
                                    ? const Color.fromRGBO(97, 42, 122, 1)
                                    : Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: _selectedDate == "augusztus 27."
                                    ? const Color.fromRGBO(97, 42, 122, 1)
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
                                    ? const Color.fromRGBO(97, 42, 122, 1)
                                    : Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: _selectedDate == "augusztus 28."
                                    ? const Color.fromRGBO(97, 42, 122, 1)
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
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      favoriteEvent.events.length,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                12,
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    254, 192, 1, 1)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  favoriteEvent.events[index]
                                                      ['name'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text(
                                                  //favoriteEvent.events[index]['place'],
                                                  "place",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                //favoriteEvent.events[index]['date'].toString(),
                                                "date",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .favorite_border_sharp),
                                                color: Colors.white,
                                                onPressed: () {
                                                  favoriteEvent.remove(
                                                      favoriteEvent
                                                          .events[index]);
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "lib/assets/event_container.png"),
                                              fit: BoxFit.contain))),
                                  onTap: () => showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          favoriteEvent.events.isNotEmpty
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.74,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color.fromRGBO(
                                                            232, 107, 62, 1),
                                                        Color.fromRGBO(
                                                            97, 42, 122, 1)
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
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child: Text(
                                                                  favoriteEvent
                                                                              .events[
                                                                          index]
                                                                      ['name'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            15),
                                                                child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        favoriteEvent.events[index]
                                                                            [
                                                                            'datetime'],
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16.5,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              20),
                                                                      Text(
                                                                        favoriteEvent.events[index]
                                                                            [
                                                                            'datetime'],
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16.5,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      )
                                                                    ]),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 20,
                                                                        left:
                                                                            15),
                                                                child: Text(
                                                                  favoriteEvent
                                                                              .events[
                                                                          index]
                                                                      ['stage'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          16.5),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          35.0),
                                                              child: Consumer<
                                                                      FavoriteModel>(
                                                                  builder: (context,
                                                                      favoriteEvent,
                                                                      child) {
                                                                return GestureDetector(
                                                                    child: Icon(
                                                                      favoriteEvent.checkFavorite(favoriteEvent.events[index]) ==
                                                                              true
                                                                          ? CupertinoIcons
                                                                              .heart_fill
                                                                          : CupertinoIcons
                                                                              .heart,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 40,
                                                                    ),
                                                                    onTap:
                                                                        () => {
                                                                              Navigator.pop(context),
                                                                              sleep(const Duration(milliseconds: 1500)),
                                                                              favoriteEvent.remove(favoriteEvent.events[index]),
                                                                            });
                                                              }))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const Text("Nincs adat")),
                                ),
                              ],
                            ),
                          )),
                ),
              ),
            ),
          ])),
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
}
