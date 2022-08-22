// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:all_in_fest/models/timed_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';
import 'package:all_in_fest/models/user.dart' as user_model;

import '../models/timed_event.dart';
import '../models/realm_connect.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedStage = "";
  String _selectedDate = "";
  final TextEditingController _searchText = TextEditingController();

  var eventsQuery;
  ImageProvider? pic;
  user_model.User? currentUser;

  late Realm eventsRealm;

  List<Text> stages = [
    const Text("Minden színpad"),
    const Text("E.ON Mainstage"),
    const Text("Miller x Wild Boar Project Stage"),
    const Text("RadioX Stage"),
    const Text("E.ON Wellnes & Chill Zone"),
    const Text("Daytime Zone"),
    const Text("Arena"),
    const Text("Gamerland"),
  ];

  @override
  void initState() {
    super.initState();

    selectToday();

    Future.delayed(Duration.zero, () => {loadEvents()});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    eventsRealm.close();
    super.dispose();
  }

  void selectToday() {
    DateTime aug26 = DateTime(2022, 8, 26);
    DateTime aug27 = DateTime(2022, 8, 27);
    DateTime aug28 = DateTime(2022, 8, 28);

    DateTime tod = DateTime.now();

    if (tod.isAfter(aug28)) {
      _selectedDate = 'augusztus 28.';
    } else if (tod.isAfter(aug27)) {
      _selectedDate = 'augusztus 27.';
    } else if (tod.isAfter(aug26)) {
      _selectedDate = 'augusztus 26.';
    } else {
      _selectedDate = 'augusztus 25.';
    }
  }

  void loadEvents() async {
    Fluttertoast.showToast(msg: 'Események betöltés alatt.');

    eventsQuery = null;

    eventsRealm =
        await RealmConnect.getRealm([TimedEvent.schema], 'EventEvent');
    RealmResults<TimedEvent> eventsQ;

    if (_selectedDate == "" && _selectedStage == "Minden színpad") {
      eventsQ = eventsRealm.all<TimedEvent>();
    } else if (_selectedDate == "" && _selectedStage != "Minden színpad") {
      eventsQ = eventsRealm.all<TimedEvent>().query(
          "stage CONTAINS '$_selectedStage' and name CONTAINS '${_searchText.text.toString()}'");
    } else if (_selectedDate != "" && _selectedStage == "Minden színpad") {
      eventsQ =
          eventsRealm.all<TimedEvent>().query("date CONTAINS '$_selectedDate'");
    } else {
      eventsQ = eventsRealm.all<TimedEvent>().query(
          "date CONTAINS '$_selectedDate' and stage CONTAINS '$_selectedStage' and name CONTAINS '${_searchText.text.toString()}'");
    }

    SubscriptionSet subscriptions = eventsRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(eventsQ, name: "Event", update: true);
    });

    await eventsRealm.subscriptions.waitForSynchronization();

    //sort the events based start time
    eventsQuery = eventsQ.toList();
    (eventsQuery as List<TimedEvent>).sort(
      (a, b) {
        return a.start!.compareTo(b.start!);
      },
    );

    if (eventsQuery.length == 0) {
      Fluttertoast.showToast(msg: "Az események nem töltödtek be.");
    }

    setState(() {});
  }

  ListView buildEvents() {
    var eventwidgets = [];
    var eventPhotos = [];

    if (eventsQuery == null) {
      loadEvents();
      return ListView();
    }

    for (var event in eventsQuery) {
      eventPhotos.add(event.image);
      eventwidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: getColor(event.stage)),
              width: MediaQuery.of(context).size.width * 0.036,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.038,
                  left: MediaQuery.of(context).size.width * 0.027),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.036),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        event.name ?? "event",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      event.stage ?? "stage",
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.038),
              child: Column(
                children: [
                  Text(
                    event.date,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    event.start + "-" + event.end,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: eventwidgets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.76,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(20),
                      topEnd: Radius.circular(20)),
                  gradient: eventsQuery[index].stage == "E.ON Mainstage"
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(254, 183, 1, 1),
                            Color.fromRGBO(97, 42, 122, 1)
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(231, 32, 67, 1),
                            Color.fromRGBO(97, 42, 122, 1)
                          ],
                        ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        eventsQuery[index].name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              eventsQuery[index].date,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              eventsQuery[index].start +
                                  "-" +
                                  eventsQuery[index].end,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.normal),
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 15),
                      child: Text(
                        eventsQuery[index].stage,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.5),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.144),
                          child: Container(
                            alignment: Alignment.center,
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.78)),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          eventsQuery[index].image),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  eventsQuery[index].description,
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.095,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("lib/assets/event_container.png"),
                          fit: BoxFit.contain)),
                  child: eventwidgets[index],
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //var favoriteEvent = context.read<FavoriteModel>();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
          title: const Image(
            image: AssetImage("lib/assets/logo.png"),
            height: 50,
            fit: BoxFit.contain,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              color: Colors.white,
              onPressed: () {
                showFilter();
              },
            )
          ],
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
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
                        if (_selectedDate != 'augusztus 25.') {
                          _selectedDate = "augusztus 25.";
                          loadEvents();
                          buildEvents();
                        }
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
                        if (_selectedDate != 'augusztus 26.') {
                          _selectedDate = "augusztus 26.";
                          loadEvents();
                          buildEvents();
                        }
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
                        if (_selectedDate != 'augusztus 27.') {
                          _selectedDate = "augusztus 27.";
                          loadEvents();
                          buildEvents();
                        }
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
                        if (_selectedDate != 'augusztus 28.') {
                          _selectedDate = "augusztus 28.";
                          loadEvents();
                          buildEvents();
                        }
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
              child: buildEvents(),
            )
          ]),
        ),
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
                    loadEvents();
                    print(_selectedStage);
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

  Color getColor(stage) {
    switch (stage) {
      case "E.ON Mainstage":
        return const Color.fromRGBO(255, 21, 1, 3);
      case "Miller x Wild Boar Project Stage":
        return const Color.fromRGBO(24, 70, 1, 1);
      case "RadioX Stage":
        return const Color.fromRGBO(114, 183, 1, 1);
      case "E.ON Wellnes & Chill Zone":
        return const Color.fromRGBO(255, 21, 1, 3);
      case "Daytime Zone":
        return const Color.fromRGBO(124, 59, 1, 1);
      case "Arena":
        return const Color.fromRGBO(204, 183, 1, 1);
      case "Gamerland":
        return const Color.fromRGBO(254, 183, 1, 1);
      default:
        return const Color.fromRGBO(254, 183, 1, 1);
    }
  }
}
