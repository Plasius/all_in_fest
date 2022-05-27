import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key})
      : super(
          key: key,
        );

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String partnerUID = "";
  String partnerName = "";
  String partnerPhoto = "";

  CollectionReference? messages;
  Stream<QuerySnapshot<Object?>>? messages_stream;

  var message = '';

  final messageInput = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      partnerUID = ModalRoute.of(context)!.settings.arguments as String;

      partnerName = partnerUID.split(" ")[1];
      partnerPhoto = partnerUID.split(" ").last;
      partnerUID = partnerUID.split(" ").first;

      print(partnerName + partnerUID);

      if (partnerUID.compareTo(FirebaseAuth.instance.currentUser!.uid) < 0) {
        messages = FirebaseFirestore.instance.collection('matches/' +
            partnerUID +
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
      }
    } catch (e) {
      print("no internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (messages == null) {
      return Scaffold(
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
            title: Text(partnerName),
          ),
          body: Stack(children: [
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
                          children: snapshot.data!.docs.map((document) {
                            if (document['user'] == partnerUID) {
                              return Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
                                              image:
                                                  NetworkImage(partnerPhoto)),
                                        ),
                                        Text(document['message'],
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22)),
                                      ]));
                            } else {
                              return Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(document['message'],
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22))
                                      ]));
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Color(0xFF000000)),
                        left: BorderSide(width: 1.0, color: Color(0xFF000000)),
                        right: BorderSide(width: 1.0, color: Color(0xFF000000)),
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xFF000000)),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextField(
                        controller: messageInput,
                        onChanged: (value) => message = value)),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                        onPressed: () {
                          messages?.add({
                            'user': FirebaseAuth.instance.currentUser!.uid,
                            'message': message,
                            'datetime': DateTime.now().millisecondsSinceEpoch
                          });

                          messageInput.clear();
                        },
                        child: const Text("Send"))),
              ]),
            )
          ]));
    }
  }
}
