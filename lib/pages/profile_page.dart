import 'dart:convert';

import 'package:all_in_fest/main.dart';
import 'package:all_in_fest/models/mongo_connect.dart';
import 'package:all_in_fest/pages/menu_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  DateTime selectedDate = DateTime.now();
  var photoURL = "";
  final ImagePicker _picker = ImagePicker();
  var _cmpressed_image;
  ImageProvider? provider = const AssetImage("lib/assets/user.png");
  var flag = false;
  String userName = "Adj meg egy nevet";
  String bio = "Adj meg egy bio-t";
  String? email = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser?.email
      : "example@bit.hu";

  var nameController = new TextEditingController();

  var bioController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = userName;
    bioController.text = bio;
    loadImage();
    loadProfile();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: MenuBar(
                imageProvider: MongoDatabase.picture != null
                    ? MongoDatabase.picture!
                    : AssetImage("lib/assets/user.png"),
                userName: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.currentUser["name"]
                    : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
                email: FirebaseAuth.instance.currentUser != null
                    ? MongoDatabase.email!
                    : ""), //MongoDatabase.email!),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              title: const Image(
                image: const AssetImage("lib/assets/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
              actions: [
                IconButton(
                  onPressed: ((() => saveProfile())),
                  icon: Icon(
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
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
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
                    color: Color.fromRGBO(97, 42, 122, 1),
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
                                  : DecorationImage(
                                      image: AssetImage("lib/assets/user.png"),
                                      fit: BoxFit.cover),
                              border:
                                  Border.all(color: Colors.white, width: 8)),
                        ),
                        Positioned(
                          child: Container(
                            height: size.width * 0.125,
                            width: size.width * 0.125,
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle),
                            child: Icon(
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
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
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
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: bioController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
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
                          FirebaseAuth.instance.signOut(),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(title: "Exited")))
                        },
                        child: Container(
                          width: size.width * 0.119,
                          height: size.width * 0.119,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(232, 107, 62, 1),
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.025),
                            child: Image(
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
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.jpeg,
            quality: 70);
      } catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    Map<String, dynamic> image = {
      "_id": pickedFile?.path.split("/").last,
      "data": base64Encode(_cmpressed_image),
      "user": FirebaseAuth.instance.currentUser?.uid
    };

    var img = await MongoDatabase.bucket.chunks
        .findOne({"user": FirebaseAuth.instance.currentUser?.uid});
    var res = img == null
        ? await MongoDatabase.bucket.chunks.insert(image)
        : await MongoDatabase.bucket.chunks.updateOne(
            mongo.where.eq('user', FirebaseAuth.instance.currentUser?.uid),
            mongo.modify.set('data', base64Encode(_cmpressed_image)));

    img = await MongoDatabase.bucket.chunks
        .findOne({"user": FirebaseAuth.instance.currentUser?.uid});

    setState(() {
      provider = MemoryImage(base64Decode(img["data"]));
      flag = true;
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print("im in");
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.heic,
            quality: 70);
      } catch (e) {
        print(e.runtimeType);
      }
    } else {
      print('No image selected.');
    }

    Map<String, dynamic> image = {
      "_id": pickedFile?.path.split("/").last,
      "data": base64Encode(_cmpressed_image),
      "user": FirebaseAuth.instance.currentUser?.uid
    };
    var img = await MongoDatabase.bucket.chunks
        .findOne({"user": FirebaseAuth.instance.currentUser?.uid});
    var res = img == null
        ? await MongoDatabase.bucket.chunks.insert(image)
        : await MongoDatabase.bucket.chunks.updateOne(
            mongo.where.eq('user', FirebaseAuth.instance.currentUser?.uid),
            mongo.modify.set('data', base64Encode(_cmpressed_image)));

    img = await MongoDatabase.bucket.chunks
        .findOne({"user": FirebaseAuth.instance.currentUser?.uid});

    setState(() {
      provider = MemoryImage(base64Decode(img["data"]));
      flag = true;
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void saveProfile() {
    //get user id
    var uid = FirebaseAuth.instance.currentUser?.uid;
    //update name
    if (uid != null) {
      if (nameController.text.isNotEmpty && bioController.text.isNotEmpty) {
        MongoDatabase.users.updateOne(
            mongo.where.eq('userID', FirebaseAuth.instance.currentUser?.uid),
            mongo.modify.set('name', nameController.text),
            mongo.modify.set('bio', bioController.text));
        print("Succeful update");
      } else if (nameController.text.isNotEmpty && bioController.text.isEmpty) {
        MongoDatabase.users.updateOne(
            mongo.where.eq('userID', FirebaseAuth.instance.currentUser?.uid),
            mongo.modify.set('name', nameController.text));
        print("Name updated");
      } else if (nameController.text.isEmpty && bioController.text.isNotEmpty) {
        MongoDatabase.users.updateOne(
            mongo.where.eq('userID', FirebaseAuth.instance.currentUser?.uid),
            mongo.modify.set('bio', bioController.text));
        print("Bio updated");
      } else {
        print("Please provide new name or bio");
      }
    }
  }

  Future<void> loadImage() async {
    if (MongoDatabase.picture == null)
      provider = AssetImage("lib/assets/user.png");
    else
      provider = MongoDatabase.picture;

    setState(() {});
  }

  void loadProfile() async {
    var user = await MongoDatabase.users.findOne(
        mongo.where.eq("userID", FirebaseAuth.instance.currentUser?.uid));
    print(user["name"]);

    setState(() {
      userName = user["name"];
      bio = user["bio"];
      nameController.text = userName;
      bioController.text = bio;
    });
  }
}
