import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  final dynamic event;
  const EventDetails({Key? key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () => Navigator.pop(context),
        builder: ((context) => Container(
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
                            child: Text(
                              event.name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    event.date,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    event.time,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.normal),
                                  )
                                ]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, left: 15),
                            child: Text(
                              event.stage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.5),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

/*   CupertinoPopupSurface(
                    isSurfacePainted: true,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.76,
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
                                    child: Text(
                                      eventsQuery[index].name,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, left: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            eventsQuery[index].date,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            eventsQuery[index].time,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20, left: 15),
                                    child: Text(
                                      eventsQuery[index].stage,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.5),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )))),
            
 */
}
