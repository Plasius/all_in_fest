import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
            leading: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            title: const Image(
              image: AssetImage("lib/assets/images/logo.png"),
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          body: 
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Térkép',
                      /*textAlign: TextAlign.left,
                      textDirection: TextDirection.rtl,*/
                      style: TextStyle(
                          fontFamily: 'Jost',
                          //fontStyle: FontStyle.italic,
                          fontSize: 42),
                    ),
                  ),
                  const Text(
                    'Térkép alcím',
                    style: TextStyle(
                        fontFamily: 'Jost',
                        fontStyle: FontStyle.italic,
                        fontSize: 22),
                  ),
                  Image.asset("lib/assets/images/angry-annoyed.gif",
                      height: 500, width: 500)
                ],
              ),
            ),
          )),
    );
  }
}
