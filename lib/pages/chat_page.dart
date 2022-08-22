// ignore_for_file: library_prefixes, implementation_imports, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:all_in_fest/models/match.dart' as swipeMatch;
import 'package:all_in_fest/models/message.dart';
import 'package:all_in_fest/models/realm_connect.dart';
import 'package:all_in_fest/models/user.dart' as user;
import 'package:all_in_fest/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realm/realm.dart';

import 'package:http/http.dart' as http;

import '../models/image.dart';
import '../models/match.dart' as match;
import '../models/token.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key,
      required this.partnerUser,
      required this.match,
      required this.firstTimeImm})
      : super(key: key);

  final user.User partnerUser;
  final swipeMatch.Match match;
  final bool firstTimeImm;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var partnerImage;
  var partnerName;
  var firstTime;
  String? token;
  bool firstLoad = true;

  late Realm tokenRealm;
  late Realm imageRealm;
  late Realm messageRealm;
  late Realm matchRealm;

  TextEditingController messageInput = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var messages = <Message>[];

  Timer? timer;

  //initializes partnerImage and partnerName
  loadPartnerNameAndImage() async {
    tokenRealm = await RealmConnect.getRealm([Token.schema], 'ChatToken');

    RealmResults<Token> tokenQuery =
        tokenRealm.query<Token>("_id CONTAINS '${widget.partnerUser.userID}'");
    SubscriptionSet tokenSubscriptions = tokenRealm.subscriptions;
    tokenSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(tokenQuery, name: "Token", update: true);
    });
    await tokenRealm.subscriptions.waitForSynchronization();
    if (tokenQuery.isEmpty == false) token = tokenQuery[0].token;

    imageRealm = await RealmConnect.getRealm([UserImage.schema], 'ChatImage');
    RealmResults<UserImage> imageQuery = imageRealm
        .all<UserImage>()
        .query("user CONTAINS '${widget.partnerUser.userID}'");
    SubscriptionSet imageSubscriptions = imageRealm.subscriptions;
    imageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(imageQuery, name: "Image", update: true);
    });
    await imageRealm.subscriptions.waitForSynchronization();

    if (imageQuery.toList().isEmpty == false) {
      var picdata = imageQuery[0];
      partnerImage = MemoryImage(base64Decode(picdata.data));
    }

    partnerName = widget.partnerUser.name;

    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //initializes messages
  loadMessages() async {
    messageRealm = await RealmConnect.getRealm([Message.schema], 'ChatMessage');
    RealmResults<Message> messageQuery = messageRealm.all<Message>().query(
        "matchID CONTAINS '${widget.partnerUser.userID}' AND matchID CONTAINS '${RealmConnect.realmUser.id}'");
    SubscriptionSet subscriptions = messageRealm.subscriptions;
    subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    await messageRealm.subscriptions.waitForSynchronization();

    int previousMessageNum = messages.length;
    messages = messageQuery.toList();

    messages.sort(
      (a, b) {
        if (a.datetime != null && b.datetime != null) {
          if (a.datetime! < b.datetime!) {
            return -1;
          } else {
            return 1;
          }
        }
        return 0;
      },
    );
    if (mounted) {
      setState(() {
        if (firstTime) {
          _showActionSheet(context);
          firstTime = false;
        }
      });
    }

    if (firstLoad == true) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      firstLoad = false;
    }

    if (previousMessageNum < messages.length) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  initState() {
    super.initState();

    firstTime = widget.firstTimeImm;

    loadPartnerNameAndImage();
    loadMessages();

    timer =
        Timer.periodic(const Duration(seconds: 3), (Timer t) => loadMessages());

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        scrollController.jumpTo(scrollController.position.minScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat page',
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              backgroundColor: const Color.fromRGBO(232, 107, 62, 1),
              title:
                  Text(partnerName.toString(), overflow: TextOverflow.ellipsis),
              actions: [
                Center(
                  child: GestureDetector(
                      onTap: () => showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: Text(
                                  "Szétválsz $partnerName-tól?",
                                ),
                                content: const Text(
                                    "Biztosan szeretnéd a szétválasztást? Így minden üzeneted törlődik"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Igen",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () => {
                                      deleteOptions(),
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage()),
                                        (Route<dynamic> route) => false,
                                      )
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text("Mégsem"),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              )),
                      child: const Text("Unmatch  ")),
                )
              ],
            ),
            body: messagesBody()));
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Válassz üdvözletet'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Majd írok én jobbat.'),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text
            onPressed: () {
              sendMessage('Szia Hölgyem/Uram!');
              Navigator.pop(context);
            },
            child: const Text('Szia Hölgyem/Uram!'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              sendMessage('Pultnál tali?');
              Navigator.pop(context);
            },
            child: const Text('Pultnál tali?'),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: false,
            onPressed: () {
              sendMessage('Egy sört csak megiszunk, nem?');
              Navigator.pop(context);
            },
            child: const Text('Egy sört csak megiszunk, nem?'),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: false,
            onPressed: () {
              sendMessage('Filmezünk az ágyban?');
              Navigator.pop(context);
            },
            child: const Text('Filmezünk az ágyban?'),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: false,
            onPressed: () {
              sendMessage('Van kedved csillagokat nézni?');
              Navigator.pop(context);
            },
            child: const Text('Van kedved csillagokat nézni?'),
          )
        ],
      ),
    );
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
      child: SingleChildScrollView(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8 - 25,
            child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                    children: List.generate(
                        messages.length,
                        (index) => messages[index].from ==
                                widget.partnerUser.userID
                            ? Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.036,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03),
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
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
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
                                              child: Text(
                                                  messages[index]
                                                      .message
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22)),
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(height: 10)
                                  ],
                                ))
                            : Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.036,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.036),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.7),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      187, 229, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
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
                                                child: Text(
                                                    messages[index]
                                                        .message
                                                        .toString(),
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(height: 10)
                                  ],
                                ),
                              )))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.065,
            ),
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
                              left:
                                  MediaQuery.of(context).size.width * 0.0325)),
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
                        sendMessage(null);
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
          ),
        ]),
      ),
    );
  }

  void sendMessage(String? text) async {
    Realm messageRealm =
        await RealmConnect.getRealm([Message.schema], 'ChatSendMessage');
    final messageQuery = messageRealm.all<Message>();
    SubscriptionSet messageSubscriptions = messageRealm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    await messageRealm.subscriptions.waitForSynchronization();

    matchRealm = await RealmConnect.getRealm([match.Match.schema], 'ChatMatch');
    final matchesQuery = matchRealm.all<match.Match>().query(
        "_id CONTAINS '${widget.match.user2}' AND _id CONTAINS '${widget.match.user1}'");
    SubscriptionSet matchesSubscription = matchRealm.subscriptions;
    matchesSubscription.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchesQuery, name: "Match", update: true);
    });
    await matchRealm.subscriptions.waitForSynchronization();

    final _message = Message(ObjectId().toString(),
        from: RealmConnect.realmUser.id,
        message: text ?? messageInput.text,
        datetime: DateTime.now().millisecondsSinceEpoch,
        matchID: widget.match.matchID);

    messageRealm.write(() {
      messageRealm.add(_message);
    });

    matchRealm.write(() {
      matchesQuery[0].lastActivity = DateTime.now().millisecondsSinceEpoch;
    });

    sendPushNotification();

    messageInput.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> deleteOptions() async {
    RealmResults<Message> messageQuery = messageRealm
        .all<Message>()
        .query("matchID CONTAINS '${widget.match.matchID}'");
    SubscriptionSet messageSubscriptions = messageRealm.subscriptions;
    messageSubscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(messageQuery, name: "Message", update: true);
    });
    await messageRealm.subscriptions.waitForSynchronization();

    matchRealm = await RealmConnect.getRealm([match.Match.schema], 'realmName');
    var matchQuery;
    matchQuery = matchRealm
        .all<swipeMatch.Match>()
        .query("_id CONTAINS '${widget.match.matchID}'");
    SubscriptionSet matchSubscription = matchRealm.subscriptions;
    matchSubscription.update((mutableSubscriptions) {
      mutableSubscriptions.add(matchQuery, name: "Match", update: true);
    });
    await matchRealm.subscriptions.waitForSynchronization();

    messageRealm.write(() => {messageRealm.deleteMany(messageQuery)});
    matchRealm.write(() => {matchRealm.deleteMany(matchQuery)});
  }

  Future<void> sendPushNotification() async {
    if (token == null) return;
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key='
                  'AAAANcIFl6A:APA91bEjrwzaHdiGzC1D_xaidEuAMvUmEmlbzD3Ehl9hj-zArI4-1WlPdDiCeb8hTLmJbcTF0aSrXAOeQBuOJ-pzl_YAFMnXoYD3-d4ogHnBYw-HS_wHAPmi1fwYr751quwV2UkoOdd-',
            },
            body: jsonEncode({
              "data": {},
              "to": token,
              "notification": {
                "title": "Kapás van!",
                "body": "Üzeneted érkezett.",
              }
            }));

    print(response.body);
  }
}
