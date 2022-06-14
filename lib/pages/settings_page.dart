import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:date_field/date_field.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  DateTime selectedDate = DateTime.now();

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

  Widget editBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/logo.png"),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                                color: Colors.grey.withOpacity(0.3))
                          ]),
                    ),
                    Positioned(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        child: Icon(
                          MdiIcons.cameraPlus,
                          color: Colors.white,
                        ),
                      ),
                      bottom: 0,
                      right: 0,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'Corfessions',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 15,
            ),
            DateTimeField(
              onDateSelected: (DateTime value) => setState(() {
                selectedDate = value;
              }),
              selectedDate: selectedDate,
              mode: DateTimeFieldPickerMode.date,
              firstDate: DateTime(1922, 1),
              lastDate: DateTime.now(),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  labelText: 'Birth date',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Major',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'Major',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Biography',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'About me',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              maxLength: 500,
              maxLines: 10,
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                'My interests',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

}
