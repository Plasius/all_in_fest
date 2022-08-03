import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
          /*appBar: AppBar(
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
          ),*/
          body: PhotoView(
              imageProvider: const AssetImage("lib/assets/terkep.png"))
          /*MediaQuery.of(context).size.height)*/

          ),
    );
  }
}
