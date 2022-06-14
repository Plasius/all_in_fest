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
      body:
        editBody()
    ));
  }

  Widget editBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            SizedBox(
              height: 20,
            ),

            TextField(
              decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'radev.anthony@uni-corvinus.hu',
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

            TextField(
              decoration: InputDecoration(
                  labelText: 'Jelszó',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'wellbe#top100',
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

            TextField(
              decoration: InputDecoration(
                  labelText: 'Jelszó újra',
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  hintText: 'wellbe#top100',
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

            const ElevatedButton(
              child: Text('Frissítés'),
              onPressed: null,
            )

          ],
        ),
      ),
    );
  }

}
