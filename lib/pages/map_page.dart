// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:all_in_fest/models/user.dart' as user_model;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var pic;
  user_model.User? currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map',
      home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Image(
              image: AssetImage("lib/assets/logo.png"),
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          body: PhotoView(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              imageProvider: const AssetImage("lib/assets/terkep.png"))
          /*MediaQuery.of(context).size.height)*/

          ),
    );
  }
}
