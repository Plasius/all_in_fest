import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
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
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    loadImage();
    super.initState();
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
                image: const AssetImage("lib/assets/images/logo.png"),
                height: 50,
                fit: BoxFit.contain,
              ),
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
              child: Center(
                child: GestureDetector(
                  onTap: () => _showPicker(context),
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage(photoURL)),
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
            TextField(
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
            DateTimeField(
              onDateSelected: (DateTime value) => setState(() {
                selectedDate = value;
              }),
              selectedDate: selectedDate,
              mode: DateTimeFieldPickerMode.date,
              firstDate: DateTime(1922, 1),
              lastDate: DateTime.now(),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  labelText: 'Születési Dátum',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
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

  void loadImage() async {
    final storageRef =
        FirebaseStorage.instanceFor(bucket: "gs://festival-2e218.appspot.com")
            .ref();
    final pathReference = storageRef.child('testimage.png');

    photoURL = await pathReference.getDownloadURL();
    setState(() {});
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  void _showPicker(context) {
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
}
