import 'package:all_in_fest/models/open_realm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../models/event.dart';
import '../models/favorite_model.dart';
import 'favorite_page.dart';
import 'menu_sidebar.dart';

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
    const Text("1. stage"),
    const Text("2. stage"),
    const Text("3. stage"),
    const Text("4. stage"),
    const Text("5. stage"),
  ];

  @override
  void initState() {
    super.initState();

    loadEvents();
  }

  void loadEvents() async {
    var appConfig = AppConfiguration("application-0-bjnqv");
    var app = App(appConfig);

    Configuration eventsConfig =
        Configuration.flexibleSync(app.currentUser!, [Event.schema]);
    Realm eventsRealm = Realm(eventsConfig);

    if (_selectedDate.isEmpty && _selectedStage.isEmpty) {
      eventsQuery = eventsRealm.all<Event>();
    } else if (_selectedDate.isEmpty && _selectedStage.isEmpty == false) {
      eventsQuery = eventsRealm
          .all<Event>()
          .query("stage CONTAINS '$_selectedStage'")
          .toList();
    } else if (_selectedDate.isEmpty == false && _selectedStage.isEmpty) {
      eventsQuery = eventsRealm
          .all<Event>()
          .query("date CONTAINS '$_selectedDate'")
          .toList();
    } else {
      eventsQuery = eventsRealm
          .all<Event>()
          .query("date CONTAINS '$_selectedDate'")
          .query("stage CONTAINS '$_selectedStage'")
          .toList();
    }

    print(eventsQuery.length);
  }

  ListView buildEvents() {
    var eventwidgets = [];

    if (eventsQuery == null) {
      loadEvents();
      return ListView();
    }

    for (var event in eventsQuery) {
      eventwidgets.add(Row(
        children: [
          Text(event.name == null ? "event" : event.name),
        ],
      ));
    }

    return ListView.builder(
      itemCount: eventwidgets.length,
      itemBuilder: (context, index) {
        return eventwidgets[index];
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
            icon: const Icon(Icons.favorite_sharp),
            color: Colors.white,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FavoritePage())),
          ),
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
