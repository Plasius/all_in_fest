import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  CollectionReference posts = FirebaseFirestore.instance.collection('feed');
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
              .collection('feed')
              .orderBy('time', descending: true)
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
              return Column(children: [
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map((document) {
                    return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Text(
                            document['message'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 22),
                          ),
                          Text(
                              DateFormat('yyyy-MM-dd - kk:mm')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      document['time']))
                                  .toString(),
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
                          posts.add({
                            'message': alert,
                            'time': DateTime.now().millisecondsSinceEpoch
                          });
                        },
                        child: const Text("Submit"))
                  ]),
              ]);
            }
          },
        )));
  }
}
