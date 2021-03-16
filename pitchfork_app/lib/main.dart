import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

String artist = "";
String album = "";

const MaterialColor kPrimaryColor = const MaterialColor(
  0xFF0E7AC7,
  const <int, Color>{
    50: const Color(0xFF0E7AC7),
    100: const Color(0xFF0E7AC7),
    200: const Color(0xFF0E7AC7),
    300: const Color(0xFF0E7AC7),
    400: const Color(0xFF0E7AC7),
    500: const Color(0xFF0E7AC7),
    600: const Color(0xFF0E7AC7),
    700: const Color(0xFF0E7AC7),
    800: const Color(0xFF0E7AC7),
    900: const Color(0xFF0E7AC7),
  },
);

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  

  

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }

  int _currentIndex = 0;

  

  final List<Widget> _children = [
    Search(),
    Explore()
    
  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Pitchfork'),
     ),
     body: _children[_currentIndex], // new
     bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, // new
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.search),
           label: 'Home',
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.music_note),
           label: 'Genres',
         ),
       ],
     ),
   );
 }
}

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var data;

  @override
  void initState() { 
    super.initState();
  }

  Future getReview(String artist, String album) async {
    _showDialog();
    var url = Uri.parse("http://192.168.1.64:5000/a=$artist&b=$album");
    await http.get(url).then((response) {
      var json1 = json.decode("[" + response.body + "]");

      if (json1[0]["status"] == false) {
        Navigator.of(context).pop();
        _showError(json1[0]["message"]);
      } else {
        setState(() {
        data = json1[0]["data"];
        });
        print(data);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewDetail(data)));
      }
    }); 
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: Container(width: 50, height: 100,child: Image.network("https://c.tenor.com/HJvqN2i4Zs4AAAAj/milk-and-mocha-cute.gif")),
          // actions: <Widget>[
          //   // usually buttons at the bottom of the dialog
          //   new TextButton(
          //     child: new Text("Close"),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  void _showError(error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: Text(error),
          actions: <Widget>[
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
          SizedBox(height: 50,),
          TextField(
            onChanged: (text) {
              artist = text;
            },
            decoration: InputDecoration(
              hintText: "Artist"
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            onChanged: (text) {
              album = text;
            },
            decoration: InputDecoration(
              hintText: "Album"
            ),
          ),
          SizedBox(height: 50,),
          ElevatedButton(
            onPressed: () {
              getReview(artist, album);
            },
            child: Text("Search"),
          )
        ],
        ),
      ),
    );
  }
}

class ReviewDetail extends StatefulWidget {
  var data;
  ReviewDetail(this.data);
  @override
  _ReviewDetailState createState() => _ReviewDetailState(data);
}

class _ReviewDetailState extends State<ReviewDetail> {

  var data;
  _ReviewDetailState(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review")
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                data["artist"],
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 20),
              Text(
                data["album"],
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 20),
              Image.network(data["cover"]),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(data["genre"],style: TextStyle(
                      color: Colors.black
                    ),),
                  Text(data["author"],style: TextStyle(
                      color: Colors.black
                    ),)
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black, width: 5),
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Text(
                    data["score"].toString(),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                data["review"],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              )
            ],
          ),
        );
       },
      ),
    );
  }
}

class Explore extends StatefulWidget {
  Explore({Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  final databaseReference = FirebaseDatabase.instance.reference().child("genre");

  List <String> genres = [];

  void readData() async{
    final database = await FirebaseDatabase.instance
        .reference()
        .child("genre")
        .once();
        
      setState(() {
        database.value.forEach((key,values) => genres.add(key));   
      });
      

      print(genres);
  }

  void readDataDetail(String genre) async{
    final database = await FirebaseDatabase.instance
        .reference()
        .child("genre")
        .child(genre)
        .once();

      List <String> bands = [];
        
      setState(() {
        database.value.forEach((key,values) => bands.add(key));   
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExploreDetail({
        "genre":genre,
        "data":bands
      })));
    
  }

  @override
  void initState() { 
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return genres.length <= 0 ? CircularProgressIndicator() : ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("As more users search for reviews, there will be more to explore here.", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
            SizedBox(height: 20),
            for(var i = 0;i<genres.length; i++) GestureDetector(
              onTap: () {
                readDataDetail(genres[i]);
              },
                child: Container(
                margin: EdgeInsets.all(10),
                color: Theme.of(context).accentColor,
                width: MediaQuery.of(context).size.width-50,
                height: 100,
                child: Center(child: Text(genres[i], style: TextStyle(fontSize: 20, color: Colors.white)))
              ),
            )
          ],
        ),
      );
     },
    );
  }
}

class ExploreDetail extends StatefulWidget {
  var data;
  ExploreDetail(this.data);

  @override
  _ExploreDetailState createState() => _ExploreDetailState(data);
}

class _ExploreDetailState extends State<ExploreDetail> {

  var data;
  _ExploreDetailState(this.data);

  @override
  void initState() { 
    super.initState();
    print(data["data"]);
  }

  void readDataDetail(String band) async{
    final database = await FirebaseDatabase.instance
        .reference()
        .child("genre")
        .child(data["genre"])
        .child(band)
        .once();

      List <String> albums = [];
        
      setState(() {
        database.value.forEach((key,values) => albums.add(key));   
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Band({
        "band":band,
        "data":albums,
        "genre":data["genre"]
      })));
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["genre"]),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            for(var i = 0;i<data["data"].length; i++) GestureDetector(
              onTap: () {
                readDataDetail(data["data"][i]);
              },
                child: Container(
                margin: EdgeInsets.all(10),
                color: Theme.of(context).accentColor,
                width: MediaQuery.of(context).size.width-50,
                height: 100,
                child: Center(child: Text(data["data"][i], style: TextStyle(fontSize: 20, color: Colors.white)))
              ),
            )
          ],
        );
      },
      ),
    );
  }
}

class Band extends StatefulWidget {
  var data;
  Band(this.data);

  @override
  _BandState createState() => _BandState(data);
}

class _BandState extends State<Band> {

  var data;
  _BandState(this.data);

  void readDataDetail(String album) async{
    final database = await FirebaseDatabase.instance
        .reference()
        .child("genre")
        .child(data["genre"])
        .child(data["band"])
        .child(album)
        .once();

      List <String> albums = [];
        

      Map<String,dynamic> review = {};
      
      setState(() {
        database.value.forEach((key,values) => review[key] = values);   
      });

      print(review);

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewDetail(review)));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["band"]),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            for(var i = 0;i<data["data"].length; i++) GestureDetector(
              onTap: () {
                readDataDetail(data["data"][i]);
              },
                child: Container(
                margin: EdgeInsets.all(10),
                color: Theme.of(context).accentColor,
                width: MediaQuery.of(context).size.width-50,
                height: 100,
                child: Center(child: Text(data["data"][i], style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,))
              ),
            )
          ],
        );
       },
      ),
    );
  }
}
