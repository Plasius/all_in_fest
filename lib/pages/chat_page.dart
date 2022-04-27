import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection('tinder/userid1_userid2/messages');
  var alert = '';
  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Feed'),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tinder/userid1_userid2/messages')
              .orderBy('time')
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
                    reverse: true,
                    children: snapshot.data!.docs.map((document) {
                      return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Text(
                              document['id'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
                            ),
                            Text(document['message'],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 22))
                          ]));
                    }).toList(),
                  ),
                  if (isAdmin)
                    Column(children: [
                      const Text('##ADMIN ZONE'),
                      TextFormField(onChanged: (value) => alert = value),
                      ElevatedButton(
                          onPressed: () {
                            messages.add({
                              'id': "user",
                              'message': alert,
                              'time': DateTime.now().millisecondsSinceEpoch
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
