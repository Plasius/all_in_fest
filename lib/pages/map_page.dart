// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:realm/realm.dart';
import 'package:all_in_fest/models/user.dart' as user_model;

import '../models/open_realm.dart';
import 'menu_sidebar.dart';

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
    Future.delayed(Duration.zero, () => loadProfile());
    getPic();
  }

  void loadProfile() async {
    RealmConnect.realmOpen();
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user_model.User.schema]);
    Realm realm = Realm(config);

    var userQuery = realm
        .all<user_model.User>()
        .query("_id CONTAINS '${RealmConnect.app.currentUser.id}'");

    SubscriptionSet userSubscriptions = realm.subscriptions;
    userSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    var user = userQuery[0];

    setState(() {
      currentUser = user;
    });
  }

  Future<void> getPic() async {
    pic = await RealmConnect.realmGetImage(RealmConnect.app.currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map',
      home: Scaffold(
          extendBodyBehindAppBar: true,
          drawer: MenuBar(
              imageProvider: pic ?? const AssetImage("lib/assets/user.png"),
              userName:
                  currentUser != null ? currentUser?.name : "Jelentkezz be!"),
          appBar: AppBar(
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
