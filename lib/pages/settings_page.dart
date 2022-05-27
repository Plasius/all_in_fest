import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      body: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              //name
              const Align(
                  alignment: Alignment.topLeft, child: Text("Change name")),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: const TextField()),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: const ElevatedButton(
                          onPressed: null, child: Text("Change"))),
                ],
              ),

              const SizedBox(height: 50),
              //email
              const Align(
                  alignment: Alignment.topLeft, child: Text("Change email")),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: const TextField()),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: const ElevatedButton(
                          onPressed: null, child: Text("Change"))),
                ],
              ),

              const SizedBox(height: 50),
              //password
              const Align(
                  alignment: Alignment.topLeft, child: Text("Change password")),

              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: const TextField()),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: const TextField()),
              ),

              const Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(onPressed: null, child: Text("Change")),
              )
            ],
          )),
    ));
  }
}
