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
          title: const Text('Festivalers'),
        ),
        body: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: null,
                  child: const Text("Swipe page",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white))),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MatchesPage())),
                child: const Text("Matches page",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
