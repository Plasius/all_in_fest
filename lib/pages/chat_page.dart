import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/mongo_connect.dart';
import 'menu_sidebar.dart';

class ChatPage extends StatefulWidget {
  final ImageProvider photo;
  final DocumentSnapshot chatPartner;
  const ChatPage({
    Key? key,
    required this.chatPartner,
    required this.photo,
  }) : super(
          key: key,
        );

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? partnerUID;
  String? partnerName;
  ImageProvider? partnerPhoto;

  CollectionReference? messages;
  Stream<QuerySnapshot<Object?>>? messages_stream;

  var message = '';

  final messageInput = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      partnerUID = widget.chatPartner.id;
      partnerName = widget.chatPartner['name'];
      partnerPhoto = widget.photo;

      print(partnerName! + partnerUID!);

      messages = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages');

      messages_stream =
          messages?.orderBy('datetime').snapshots(includeMetadataChanges: true);

      /*if (partnerUID?.compareTo(FirebaseAuth.instance.currentUser!.uid) != 0) {
        messages = FirebaseFirestore.instance.collection('matches/' +
            partnerUID! +
            '_' +
            FirebaseAuth.instance.currentUser!.uid +
            '/messages');
        messages_stream = messages
            ?.orderBy('datetime')
            .snapshots(includeMetadataChanges: true);
        print('matches/' +
            partnerUID +
            '_' +
            FirebaseAuth.instance.currentUser!.uid +
            '/messages');
      } else {
        messages = FirebaseFirestore.instance.collection('matches/' +
            FirebaseAuth.instance.currentUser!.uid +
            '_' +
            partnerUID +
            '/messages');
        messages_stream = messages
            ?.orderBy('datetime')
            .snapshots(includeMetadataChanges: true);
        print('matches/' +
            FirebaseAuth.instance.currentUser!.uid +
            '_' +
            partnerUID +
            '/messages');
      }*/
    } catch (e) {
      print("no internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (messages == null) {
      return Scaffold(
          drawer: MenuBar(
              imageProvider: FirebaseAuth.instance.currentUser != null
                  ? MongoDatabase.picture!
                  : AssetImage("lib/assets/user.png"),
              userName: FirebaseAuth.instance.currentUser!=null ? MongoDatabase.currentUser["name"] : "Jelentkezz be!", //MongoDatabase.currentUser["name"],
              email: FirebaseAuth.instance.currentUser!=null ? MongoDatabase.email! : ""),//MongoDatabase.email!),
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
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
            title: Text(partnerName!),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(232, 107, 62, 1),
                Color.fromRGBO(97, 42, 122, 1)
              ],
            )),
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.80,
                child: SingleChildScrollView(
                    child: StreamBuilder(
                  stream: messages_stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text('Loading');
                    } else {
                      return Column(
                        children: [
                          ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .where((element) => element
                                    .get('users')
                                    .toString()
                                    .contains(partnerUID!))
                                .map((document) {
                              if (document['from'] == partnerUID) {
                                return Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.043),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: partnerPhoto!,
                                                        fit: BoxFit.cover)),

                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                              borderRadius: BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.036,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.018),
                                                child: Text(document['message'],
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ])),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.05),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      187, 229, 243, 1),
                                              borderRadius: BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.036,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.018),
                                                child: Text(document['message'],
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22)),
                                              ),
                                            )
                                          ])),
                                );
                              }
                            }).toList(),
                          )
                        ],
                      );
                    }
                  },
                )),
              ),
              /*CHATBOX AND SEND BUTTON*/
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.065),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.036),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(254, 254, 254, 1),
                                width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width * 0.68,
                        height: MediaQuery.of(context).size.height * 0.045,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(254, 254, 254, 1),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              fillColor: Color.fromRGBO(97, 42, 122, 1),
                              hintText: "Üzenet írása...",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.0325)),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          controller: messageInput,
                          onChanged: (value) => message = value,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          messages?.add({
                            'from': FirebaseAuth.instance.currentUser!.uid,
                            'users': partnerUID! +
                                FirebaseAuth.instance.currentUser!.uid,
                            'message': message,
                            'datetime': DateTime.now().millisecondsSinceEpoch
                          });
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(partnerUID)
                              .collection('messages')
                              .add({
                            'from': FirebaseAuth.instance.currentUser!.uid,
                            'users': partnerUID! +
                                FirebaseAuth.instance.currentUser!.uid,
                            'message': message,
                            'datetime': DateTime.now().millisecondsSinceEpoch
                          });
                          messageInput.clear();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.145,
                          height: MediaQuery.of(context).size.height * 0.045,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(97, 42, 122, 1),
                              border: Border.all(
                                  color: Color.fromRGBO(254, 254, 254, 1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.043,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.011),
                            child: const Image(
                              image: AssetImage('lib/assets/send_message.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ]),
                ),
              )
            ]),
          ));
    }
  }
}
