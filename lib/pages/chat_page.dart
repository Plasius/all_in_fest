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

  late CollectionReference messages;
  late var messages_stream;

  var message = '';

  final messageInput = TextEditingController();

  final conversationController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    partnerUID = ModalRoute.of(context)!.settings.arguments as String;
    partnerName = partnerUID.split(" ").last;
    partnerUID = partnerUID.split(" ").first;

    print(partnerName + partnerUID);

    if (partnerUID.compareTo(FirebaseAuth.instance.currentUser!.uid) < 0) {
      messages = FirebaseFirestore.instance.collection('matches/' +
          partnerUID +
          '_' +
          FirebaseAuth.instance.currentUser!.uid +
          '/messages');
      messages_stream =
          messages.orderBy('datetime').snapshots(includeMetadataChanges: true);
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
      messages_stream =
          messages.orderBy('datetime').snapshots(includeMetadataChanges: true);
      print('matches/' +
          FirebaseAuth.instance.currentUser!.uid +
          '_' +
          partnerUID +
          '/messages');
    }
    messages_stream.listen((snapshot) {
      conversationController.animateTo(
        433333.0,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                controller: conversationController,
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
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Image(
                                                fit: BoxFit.cover,
                                                width: 40,
                                                height: 40,
                                                image: NetworkImage(
                                                    'https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/wp-content/uploads/2021/04/dogecoin.jpeg.jpg')),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
          Align(
            alignment: Alignment.bottomCenter,

            ///Your TextBox Container
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Color(0xFF000000)),
                      left: BorderSide(width: 1.0, color: Color(0xFF000000)),
                      right: BorderSide(width: 1.0, color: Color(0xFF000000)),
                      bottom: BorderSide(width: 1.0, color: Color(0xFF000000)),
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
                        messages.add({
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

  sendMyMessage(int index) {
    messages.add({
      'id': "userid" + index.toString(),
      'message': "message" + index.toString()
    });
    Navigator.pop(context);
  }
}
