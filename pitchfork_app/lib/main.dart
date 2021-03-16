import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

String artist = "";
String album = "";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    PlaceholderWidget(Colors.white),
    
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
      
      setState(() {
        data = json1[0]["data"];
      });
      print(data);
      Navigator.of(context).pop();
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
          content: Container(width: 50, height: 100,child: new CircularProgressIndicator()),
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



class PlaceholderWidget extends StatelessWidget {
 final Color color;

 PlaceholderWidget(this.color);

 @override
 Widget build(BuildContext context) {
   return Container(
     color: color,
   );
 }
}