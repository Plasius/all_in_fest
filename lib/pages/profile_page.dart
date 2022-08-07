// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:all_in_fest/main.dart';
import 'package:all_in_fest/models/image.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/models/user.dart' as user_model;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realm/realm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime selectedDate = DateTime.now();
  var photoURL = "";
  final ImagePicker _picker = ImagePicker();
  ImageProvider? provider = const AssetImage("lib/assets/user.png");
  var flag = false;
  String userName = "Adj meg egy nevet";
  String bio = "Adj meg egy bio-t";
  String? email = "example@bit.hu";

  var nameController = TextEditingController();

  var bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = userName;
    bioController.text = bio;
    RealmConnect.realmOpen();
    loadImage();
    Future.delayed(
        Duration.zero,
        (() => {
              loadProfile(),
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            /* drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : const AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""),  */ //MongoDatabase.email!),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              title: const Image(
                image: AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
              actions: [
                IconButton(
                  onPressed: ((() => saveProfile())),
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            body: editBody(context)));
  }

  Widget editBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/profile.png"), fit: BoxFit.cover)),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                  top: MediaQuery.of(context).size.height * 0.15,
                  bottom: MediaQuery.of(context).size.height * 0.026),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(97, 42, 122, 1),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.061,
                          right: size.width * 0.061,
                          bottom: size.width * 0.041,
                          top: size.width * 0.041),
                      child: Stack(children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: MediaQuery.of(context).size.width * 0.55,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: provider != null
                                  ? DecorationImage(
                                      image: provider!, fit: BoxFit.cover)
                                  : const DecorationImage(
                                      image: AssetImage("lib/assets/user.png"),
                                      fit: BoxFit.cover),
                              border:
                                  Border.all(color: Colors.white, width: 8)),
                        ),
                        Positioned(
                          child: GestureDetector(
                            onTap: (() => _showPicker(context)),
                            child: Container(
                              height: size.width * 0.125,
                              width: size.width * 0.125,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(232, 107, 62, 1),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                MdiIcons.cameraPlus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          bottom: size.width * 0,
                          right: size.width * 0.04,
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.061,
                          right: size.width * 0.061,
                          bottom: size.width * 0.041,
                          top: size.width * 0.041),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.4),
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22),
                              contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.0325)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.061,
                          right: size.width * 0.061,
                          bottom: size.width * 0.061,
                          top: size.width * 0.041),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.4),
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: bioController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22),
                              contentPadding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.0325)),
                          maxLines: 9,
                          maxLength: 500,
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => {
                          RealmConnect.app.currentUser.logOut(),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: "Exited")))
                        },
                        child: Container(
                          width: size.width * 0.119,
                          height: size.width * 0.119,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(232, 107, 62, 1),
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.025),
                            child: const Image(
                              image: AssetImage("lib/assets/logout.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future imgFromGallery() async {
    var imageQuery;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var _cmpressed_image;
      print("im in");
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.jpeg,
            quality: 70);

        var image = UserImage(pickedFile.path.split("/").last,
            base64Encode(_cmpressed_image), RealmConnect.app.currentUser.id);

        RealmConnect.realmOpen();
        Configuration config = Configuration.flexibleSync(
            RealmConnect.app.currentUser, [UserImage.schema]);
        Realm realm = Realm(config);

        imageQuery = realm.all<UserImage>();
        SubscriptionSet messageSubscriptions = realm.subscriptions;
        messageSubscriptions.update((mutableSubscriptions) {
          mutableSubscriptions.add(imageQuery, name: "Image", update: true);
        });
        await realm.subscriptions.waitForSynchronization();

        await RealmConnect.realmDeleteImage();

        realm.write(() => realm.add(image));
      } catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    var img = imageQuery
        .query("user CONTAINS '${RealmConnect.app.currentUser.id}'")[0];

    setState(() {
      provider = MemoryImage(base64Decode(img.data));
      flag = true;
    });
  }

  Future imgFromCamera() async {
    var imageQuery;
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      var _cmpressed_image;
      print("im in");
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.jpeg,
            quality: 70);

        var image = UserImage(pickedFile.path.split("/").last,
            base64Encode(_cmpressed_image), RealmConnect.app.currentUser.id);

        RealmConnect.realmOpen();
        Configuration config = Configuration.flexibleSync(
            RealmConnect.app.currentUser, [UserImage.schema]);
        Realm realm = Realm(config);

        imageQuery = realm.all<UserImage>();
        SubscriptionSet messageSubscriptions = realm.subscriptions;
        messageSubscriptions.update((mutableSubscriptions) {
          mutableSubscriptions.add(imageQuery, name: "Image", update: true);
        });
        await realm.subscriptions.waitForSynchronization();

        await RealmConnect.realmDeleteImage();

        realm.write(() => realm.add(image));
      } catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    var img = imageQuery
        .query("user CONTAINS '${RealmConnect.app.currentUser.id}'")[0];

    setState(() {
      provider = MemoryImage(base64Decode(img.data));
      flag = true;
    });
  }

  Future<void> saveProfile() async {
    //get user id and realm connection
    var uid = RealmConnect.app.currentUser.id;
    RealmConnect.realmOpen();
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [user_model.User.schema]);
    Realm realm = Realm(config);

    var userQuery = realm.all<user_model.User>().query("_id == '$uid'");
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    //update name
    if (uid != null) {
      user_model.User myUser = userQuery[0];
      if (nameController.text.isNotEmpty && bioController.text.isNotEmpty) {
        realm.write(() => {
              myUser.name = nameController.text,
              myUser.bio = bioController.text
            });
        print("Succeful update");
      } else if (nameController.text.isNotEmpty && bioController.text.isEmpty) {
        realm.write(() => {myUser.name = nameController.text});
        print("Name updated");
      } else if (nameController.text.isEmpty && bioController.text.isNotEmpty) {
        realm.write(() => {myUser.bio = bioController.text});
        print("Bio updated");
      } else {
        print("Please provide new name or bio");
      }
    }
  }

  Future<void> loadImage() async {
    RealmConnect.realmGetImage();
    if (RealmConnect.picture == null) {
      provider = const AssetImage("lib/assets/user.png");
    } else {
      provider = RealmConnect.picture;
    }

    setState(() {});
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
    print(user.name);

    setState(() {
      userName = user.name!;
      bio = user.bio!;
      nameController.text = userName;
      bioController.text = bio;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
