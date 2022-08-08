// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';

import '../models/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedStage = "";
  String _selectedDate = "";

  var eventsQuery;

  List<Text> stages = [
    const Text(""),
    const Text("E.ON Mainstage"),
    const Text("Miller x Wild Boar Project Stage"),
  ];

  @override
  void initState() {
    super.initState();

    loadEvents();
  }

  void loadEvents() async {
    RealmResults<Event> eventsQ;

    var appConfig = AppConfiguration("application-0-bjnqv");
    var app = App(appConfig);

    Configuration eventsConfig =
        Configuration.flexibleSync(app.currentUser!, [Event.schema]);
    Realm eventsRealm = Realm(eventsConfig);

    if (_selectedDate == "" && _selectedStage == "") {
      eventsQ = eventsRealm.all<Event>();
    } else if (_selectedDate == "" && _selectedStage != "") {
      eventsQ =
          eventsRealm.all<Event>().query("stage CONTAINS '$_selectedStage'");
    } else if (_selectedDate != "" && _selectedStage == "") {
      eventsQ =
          eventsRealm.all<Event>().query("date CONTAINS '$_selectedDate'");
    } else {
      eventsQ = eventsRealm.all<Event>().query(
          "date CONTAINS '$_selectedDate' and stage CONTAINS '$_selectedStage'");
    }

    SubscriptionSet subscriptions = eventsRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(eventsQ, name: "events", update: true);
    });

    await eventsRealm.subscriptions.waitForSynchronization();

    eventsQuery = eventsQ.toList();

    if (eventsQuery.length == 0) {
      Fluttertoast.showToast(
          msg: "Az események még nem töltödtek be.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
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
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.036,
              right: MediaQuery.of(context).size.width * 0.036,
              top: MediaQuery.of(context).size.width * 0.054),
          child: Row(
            children: [
              Column(
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
              Column(
                children: [
                  Text(
                    event.date,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    event.time,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: eventwidgets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
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
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
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
                              eventsQuery[index].time,
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
                            width: MediaQuery.of(context).size.width * 0.664,
                            height: MediaQuery.of(context).size.height * 0.33,
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
                    Padding(
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
                    )
                  ],
                ),
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.095,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: eventsQuery[index].stage == "E.ON Mainstage"
                            ? Colors.yellow
                            : Colors.orange),
                    width: MediaQuery.of(context).size.width * 0.036,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.095,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("lib/assets/event_container.png"),
                    )),
                    child: Row(
                      children: [
                        Column(
                          children: [eventwidgets[index]],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //var favoriteEvent = context.read<FavoriteModel>();
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
        /*leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),*/
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
                      loadEvents();
                      buildEvents();
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
                      loadEvents();
                      buildEvents();
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
                      loadEvents();
                      buildEvents();
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
                      loadEvents();
                      buildEvents();
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
