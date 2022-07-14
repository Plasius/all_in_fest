import 'dart:convert';

import 'package:all_in_fest/main.dart';
import 'package:all_in_fest/models/mongo_connect.dart';
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
  ImageProvider? provider;
  var flag = false;

  var nameController = new TextEditingController();

  var bioController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              leading: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: provider != null
                                ? DecorationImage(image: provider!)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                  color: Colors.grey.withOpacity(0.3))
                            ]),
                      ),
                      Positioned(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: Icon(
                            MdiIcons.cameraPlus,
                            color: Colors.white,
                          ),
                        ),
                        bottom: 0,
                        right: 0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Név',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'Anthony Radev',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: bioController,
              decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'Rólam',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              maxLength: 500,
              maxLines: 10,
            ),
            SizedBox(
              height: 15,
            ),
            IconButton(
                onPressed: () => {
                      FirebaseAuth.instance.signOut(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: "Exited")))
                    },
                icon: Icon(Icons.exit_to_app))

            /*Center(
              child: Text(
                'My interests',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),*/
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
    var img = await MongoDatabase.bucket.chunks
        .findOne({"user": FirebaseAuth.instance.currentUser?.uid});
    setState(() {
      provider = MemoryImage(base64Decode(img["data"]));
    });
  }
}
