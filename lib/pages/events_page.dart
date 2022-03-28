import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        1,
                        (index) => Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Column(
                                  children: [
                                    Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://scontent-vie1-1.xx.fbcdn.net/v/t39.30808-6/275380272_155581196865474_7845633093102862446_n.jpg?_nc_cat=108&ccb=1-5&_nc_sid=340051&_nc_ohc=c4rAaKzUwG8AX9loQc1&_nc_ht=scontent-vie1-1.xx&oh=00_AT9RGsV33FY2ZgwPtNYT9dzD74cwOTWN6FegFbW492aatg&oe=62470107"),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    document['name'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22,
                                                        fontFamily: 'Schyler'),
                                                  ),
                                                  Text(DateTime.now()
                                                      .year
                                                      .toString())
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Read more",
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        fontSize: 14,
                                                        fontFamily: 'Schyler'),
                                                  ),
                                                  Icon(
                                                    Icons.chevron_right,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 5,
                                                  color: Colors.grey
                                                      .withOpacity(0.8))
                                            ])),
                                  ],
                                ),
                              ),
                            )),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    ));
  }
}
