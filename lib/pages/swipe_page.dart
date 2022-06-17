import 'package:all_in_fest/pages/matches_page.dart';
import 'package:flutter/material.dart';


class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
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
        body: swipeBody()
      ),
    );
  }
  Widget swipeBody() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height,
      ),
    );
  }

}
