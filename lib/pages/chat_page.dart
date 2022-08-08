// ignore_for_file: library_prefixes, implementation_imports, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:all_in_fest/models/match.dart' as swipeMatch;
import 'package:all_in_fest/models/message.dart';
import 'package:all_in_fest/models/open_realm.dart';
import 'package:all_in_fest/models/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';

import '../models/image.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.partnerUser, required this.match})
      : super(key: key);

  final user.User partnerUser;
  final swipeMatch.Match match;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var partnerImage;
  var partnerName;

  TextEditingController messageInput = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <Message>[];

  Timer? timer;

  //initializes partnerImage and partnerName
  loadPartnerNameAndImage() async {
    RealmResults<UserImage> imageQuery;
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [UserImage.schema]);
    Realm realm = Realm(config);
    imageQuery = realm
        .all<UserImage>()
        .query("user CONTAINS '${widget.partnerUser.userID}'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      var picdata = imageQuery[0];
      partnerImage = MemoryImage(base64Decode(picdata.data));
    }

    partnerName = widget.partnerUser.name;
    setState(() {});
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  //initializes messages
  loadMessages() async {
    var appConfig = AppConfiguration("application-0-bjnqv");
    var app = App(appConfig);

    RealmResults<Message> messageQuery;
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Message.schema]);
    Realm realm = Realm(config);
    messageQuery = realm.all<Message>().query(
        "matchID CONTAINS '${widget.partnerUser.userID}' AND matchID CONTAINS '${app.currentUser?.id.toString()}'");

    SubscriptionSet subscriptions = realm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });

    await realm.subscriptions.waitForSynchronization();

    messages = messageQuery.toList();

    setState(() {});

    Future.delayed(const Duration(milliseconds: 1000), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  initState() {
    super.initState();
    loadPartnerNameAndImage();
    loadMessages();

    timer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => loadMessages());

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        scrollController.jumpTo(scrollController.position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat page',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              title: Text(partnerName.toString()),
            ),
            body: messagesBody()));
  }

  Widget messagesBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(232, 107, 62, 1),
            Color.fromRGBO(97, 42, 122, 1)
          ],
        ),
      ),
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8 - 50,
          child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                  children: List.generate(
                      messages.length,
                      (index) => messages[index].from ==
                              widget.partnerUser.userID
                          ? Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          image: partnerImage == null
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      "lib/assets/user.png"),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: partnerImage),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.036,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.018),
                                        child: Text(
                                            messages[index].message.toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22)),
                                      ),
                                    ),
                                    const SizedBox(height: 50)
                                  ]))
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.036,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.018),
                                        child: Text(
                                            messages[index].message.toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22)),
                                      ),
                                    ),
                                    const SizedBox(height: 50)
                                  ]))))),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.065),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.036),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(254, 254, 254, 1),
                          width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width * 0.68,
                  height: MediaQuery.of(context).size.height * 0.045,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(254, 254, 254, 1),
                                width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        fillColor: const Color.fromRGBO(97, 42, 122, 1),
                        hintText: "Üzenet írása...",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0325)),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    controller: messageInput,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    if (messageInput.text.isNotEmpty) {
                      sendMessage();
                    } else {
                      Fluttertoast.showToast(msg: "Írj üzenetet!");
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.145,
                    height: MediaQuery.of(context).size.height * 0.045,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(97, 42, 122, 1),
                        border: Border.all(
                            color: const Color.fromRGBO(254, 254, 254, 1),
                            width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.043,
                          vertical: MediaQuery.of(context).size.height * 0.011),
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
    );
  }

  void sendMessage() async {
    Configuration config = Configuration.flexibleSync(
        RealmConnect.app.currentUser, [Message.schema]);
    Realm realm = Realm(config);
    final messageQuery = realm.all<Message>();
    SubscriptionSet messageSubscriptions = realm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    await realm.subscriptions.waitForSynchronization();

    final _message = Message(ObjectId().toString(),
        from: RealmConnect.app.currentUser.id,
        message: messageInput.text,
        datetime: DateTime.now().millisecondsSinceEpoch,
        matchID: widget.match.matchID);

    realm.write(() {
      realm.add(_message);
    });

    messageInput.clear();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
