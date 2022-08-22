// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:all_in_fest/models/image.dart';
import 'package:all_in_fest/models/realm_connect.dart';
import 'package:all_in_fest/models/user.dart' as user_model;
import 'package:all_in_fest/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String userName = "Betöltés alatt.";
  String bio = "Betöltés alatt.";

  var nameController = TextEditingController();

  var bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = userName;
    bioController.text = bio;

    Future.delayed(
        Duration.zero,
        (() => {
              loadImage(),
              loadProfile(),
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: ((() => saveProfile())),
                    child: const Text(
                      'Mentés  ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
              title: const Image(
                image: AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
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
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          maxLength: 12,
                          maxLines: 1,
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
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
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
            base64Encode(_cmpressed_image), RealmConnect.currentUser.id);

        imageQuery = RealmConnect.realm.all<UserImage>();
        SubscriptionSet messageSubscriptions = RealmConnect.realm.subscriptions;
        messageSubscriptions.update((mutableSubscriptions) {
          mutableSubscriptions.add(imageQuery, name: "Image", update: true);
        });
        await RealmConnect.realm.subscriptions.waitForSynchronization();

        await RealmConnect.realmDeleteImage();

        RealmConnect.realm.write(() => RealmConnect.realm.add(image));

        setState(() {});
      } catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    var img =
        imageQuery.query("user CONTAINS '${RealmConnect.currentUser.id}'")[0];

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
            base64Encode(_cmpressed_image), RealmConnect.currentUser.id);

        imageQuery = RealmConnect.realm.all<UserImage>();
        SubscriptionSet messageSubscriptions = RealmConnect.realm.subscriptions;
        messageSubscriptions.update((mutableSubscriptions) {
          mutableSubscriptions.add(imageQuery, name: "Image", update: true);
        });
        await RealmConnect.realm.subscriptions.waitForSynchronization();

        await RealmConnect.realmDeleteImage();

        RealmConnect.realm.write(() => RealmConnect.realm.add(image));
        setState(() {});
      } catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    var img =
        imageQuery.query("user CONTAINS '${RealmConnect.currentUser.id}'")[0];

    setState(() {
      provider = MemoryImage(base64Decode(img.data));
      flag = true;
    });
  }

  Future<void> saveProfile() async {
    //get user id and realm connection
    var uid = RealmConnect.currentUser.id;

    var userQuery =
        RealmConnect.realm.all<user_model.User>().query("_id == '$uid'");
    SubscriptionSet messageSubscriptions = RealmConnect.realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await RealmConnect.realm.subscriptions.waitForSynchronization();

    //update name
    if (uid != null) {
      user_model.User myUser = userQuery[0];
      if (nameController.text.isNotEmpty && bioController.text.isNotEmpty) {
        RealmConnect.realm.write(() => {
              myUser.name = nameController.text,
              myUser.bio = bioController.text
            });
        Fluttertoast.showToast(msg: 'Adatok frissítve.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (Route<dynamic> route) => false,
        );
      } else if (nameController.text.isNotEmpty && bioController.text.isEmpty) {
        RealmConnect.realm.write(() => {myUser.name = nameController.text});
        Fluttertoast.showToast(msg: 'Név frissítve.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (Route<dynamic> route) => false,
        );
      } else if (nameController.text.isEmpty && bioController.text.isNotEmpty) {
        RealmConnect.realm.write(() => {myUser.bio = bioController.text});
        Fluttertoast.showToast(msg: 'Bio frissítve.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        print("Please provide new name or bio");
      }
    }
  }

  Future<void> loadImage() async {
    var pic = await RealmConnect.realmGetImage(
        RealmConnect.currentUser!.id.toString());
    if (pic == null) {
      provider = const AssetImage("lib/assets/user.png");
    } else {
      provider = pic;
    }

    setState(() {});
  }

  void loadProfile() async {
    var userQuery = RealmConnect.realm
        .all<user_model.User>()
        .query("_id CONTAINS '${RealmConnect.currentUser.id}'");

    SubscriptionSet userSubscriptions = RealmConnect.realm.subscriptions;
    userSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(userQuery, name: "User", update: true);
    });
    await RealmConnect.realm.subscriptions.waitForSynchronization();

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
