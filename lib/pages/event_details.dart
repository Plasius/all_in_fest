import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 107, 62, 1),
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Image(
          image: AssetImage("lib/assets/images/logo.png"),
          height: 50,
          fit: BoxFit.contain,
        ),
        actions: [
          Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite_sharp,
            color: Colors.white,
          ),
          Icon(
            Icons.filter_alt_outlined,
            color: Colors.white,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(97, 42, 122, 1)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Fellépő neve", style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold
                      ),),
                      Row(
                        children: [
                          Text("Nap", style: TextStyle(
                            color: Colors.white
                          ),),
                          Text("9:50-11:20", style: TextStyle(
                            color: Colors.white
                          ),)
                        ],
                      ),
                      Text("Helyszín", style: TextStyle(
                        color: Colors.white
                      ),)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Icon(Icons.favorite_border_sharp, color: Colors.white,),
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  height: MediaQuery.of(context).size.height/3,
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Image(
                    image: AssetImage("lib/assets/images/artist.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
