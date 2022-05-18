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

  var message = '';

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
      print('matches/' +
          FirebaseAuth.instance.currentUser!.uid +
          '_' +
          partnerUID +
          '/messages');
    }
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(partnerName),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
          stream: messages
              .orderBy('datetime')
              .snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
            } else {
              return Column(
                children: [
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Text((() {
                              if (document['user'] == partnerUID) {
                                return partnerName;
                              } else {
                                return "Me";
                              }
                            })()),
                            Text(document['message'],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 22))
                          ]));
                    }).toList(),
                  ),
                  Column(children: [
                    TextFormField(onChanged: (value) => message = value),
                    ElevatedButton(
                        onPressed: () {
                          messages.add({
                            'user': FirebaseAuth.instance.currentUser!.uid,
                            'message': message,
                            'datetime': DateTime.now().millisecondsSinceEpoch
                          });
                        },
                        child: const Text("Submit"))
                  ]),
                ],
              );
            }
          },
        )));
  }

  Widget setupAlertDialoadContainer() {
    return SizedBox(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: ElevatedButton(
              onPressed: () {
                sendMyMessage(index);
              },
              child: const Text("click me"),
            ),
          );
        },
      ),
    );
  }

  sendMyMessage(int index) {
    messages.add({
      'id': "userid" + index.toString(),
      'message': "message" + index.toString()
    });
    Navigator.pop(context);
  }
}
