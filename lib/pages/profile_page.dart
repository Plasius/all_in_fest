// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:all_in_fest/main.dart';
import 'package:all_in_fest/models/mongo_connect.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/pages/menu_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:image_picker/image_picker.dart';

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
    loadImage();
    loadProfile();
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
                          child: Container(
                            height: size.width * 0.125,
                            width: size.width * 0.125,
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle),
                            child: const Icon(
                              MdiIcons.cameraPlus,
                              color: Colors.white,
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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("im in");
      try {} catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    var img = await MongoDatabase.bucket.chunks
        .findOne({"user": RealmConnect.app.currentUser.id});

    img = await MongoDatabase.bucket.chunks
        .findOne({"user": RealmConnect.app.currentUser.id});

    setState(() {
      provider = MemoryImage(base64Decode(img["data"]));
      flag = true;
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print("im in");
      try {} catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    var img = await MongoDatabase.bucket.chunks
        .findOne({"user": RealmConnect.app.currentUser.id});

    img = await MongoDatabase.bucket.chunks
        .findOne({"user": RealmConnect.app.currentUser.id});

    setState(() {
      provider = MemoryImage(base64Decode(img["data"]));
      flag = true;
    });
  }

  void saveProfile() {
    //get user id
    var uid = RealmConnect.app.currentUser.id;
    //update name
    if (uid != null) {
      if (nameController.text.isNotEmpty && bioController.text.isNotEmpty) {
        MongoDatabase.users.updateOne(
            mongo.where.eq('userID', RealmConnect.app.currentUser.id),
            mongo.modify.set('name', nameController.text),
            mongo.modify.set('bio', bioController.text));
        print("Succeful update");
      } else if (nameController.text.isNotEmpty && bioController.text.isEmpty) {
        MongoDatabase.users.updateOne(
            mongo.where.eq('userID', RealmConnect.app.currentUser.id),
            mongo.modify.set('name', nameController.text));
        print("Name updated");
      } else if (nameController.text.isEmpty && bioController.text.isNotEmpty) {
        MongoDatabase.users.updateOne(
            mongo.where.eq('userID', RealmConnect.app.currentUser.id),
            mongo.modify.set('bio', bioController.text));
        print("Bio updated");
      } else {
        print("Please provide new name or bio");
      }
    }
  }

  Future<void> loadImage() async {
    if (MongoDatabase.picture == null) {
      provider = const AssetImage("lib/assets/user.png");
    } else {
      provider = MongoDatabase.picture;
    }

    setState(() {});
  }

  void loadProfile() async {
    var user = await MongoDatabase.users
        .findOne(mongo.where.eq("userID", RealmConnect.app.currentUser.id));
    print(user["name"]);

    setState(() {
      userName = user["name"];
      bio = user["bio"];
      nameController.text = userName;
      bioController.text = bio;
    });
  }
}
