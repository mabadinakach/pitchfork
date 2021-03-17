import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

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
       title: Text('Pitchfork Client App'),
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
    artist = "";
    album = "";
  }

  Future getReview(String artist, String album) async {
    _showDialog();
    var url = Uri.parse("http://192.168.1.64:5000/a=$artist&b=$album");
    await http.get(url).then((response) {
      if (response.statusCode != 200) {
        Navigator.of(context).pop();
        _showError("Error: ${response.statusCode}");
      }
      var json1 = json.decode("[" + response.body + "]");
      print(response.statusCode);
      
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(width: 50, height: 100,child: Image.network("https://media3.giphy.com/media/gdTk7DyjblYWyqyBhG/giphy.gif")),
        );
      },
    );
  }

  void _showError(error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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

  List<Image> images = [
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603208225015-DJ9F5QMIY8SL2HL1FK6S/ke17ZwdGBToddI8pDm48kB9VQfqtly6fKqkiYCkPXaFZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyn6gQ4NFdQ7R4MR6wxnXbxgJd6wf4utYaxP954dD4SXKzitVMbPRi_LQvaXUdzF4Y/Screen+Shot+2020-10-20+at+11.36.46+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603208312230-K6CHZPQOCEFKI2LHDJKE/ke17ZwdGBToddI8pDm48kNb_7ypA_97UsF9m0cdu7zhZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpzGdIKNtx6iBSa8b6m2ZOvcEYY1k593GJ5Dnhz7BHNowinbPXj6twav4Aph9JbyP-w/Screen+Shot+2020-10-20+at+11.38.19+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603208565381-AY8FVBNGM6TMOMJPFIJW/ke17ZwdGBToddI8pDm48kLxMzUo65OKC-k7qJ3953dlZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyf0mNtCa6kd1EiReSwtkHLow6cvoYhSYjlzz29zCx-mdhztxC8JdfFZ2hWg6OE7k0/Screen+Shot+2020-10-20+at+11.42.27+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603208885401-D1X1N2782M20BKNQYO2Q/ke17ZwdGBToddI8pDm48kLxMzUo65OKC-k7qJ3953dlZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyf0mNtCa6kd1EiReSwtkHLow6cvoYhSYjlzz29zCx-mdhztxC8JdfFZ2hWg6OE7k0/Screen+Shot+2020-10-20+at+11.43.39+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603208945539-V7IT7YOD6ZRRF1RJBW2Y/ke17ZwdGBToddI8pDm48kLxMzUo65OKC-k7qJ3953dlZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyf0mNtCa6kd1EiReSwtkHLow6cvoYhSYjlzz29zCx-mdhztxC8JdfFZ2hWg6OE7k0/Screen+Shot+2020-10-20+at+11.48.51+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209010717-IMH38WH2XS0AOEK6ZZ8Z/ke17ZwdGBToddI8pDm48kPjeJAm00CDHWh_ZMgXjEWNZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpz4rSyg3jA_cSuDPSO-0PpgqXrlfAT89Ia_69KV_pyRiZvZCzjgv3X8ZCe8_Y-5Jpw/Screen+Shot+2020-10-20+at+11.49.58+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603211152010-DSPG8MGYQWRTSNSWGL5N/ke17ZwdGBToddI8pDm48kDHnLv2JTc2j110zwWiPDQ9Zw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpx9MNbzgNsBi34wnReUFO4zdGl9QjvD6nb9gAQKsS-3xXYK4AuBCyLWKDff_EX6ut4/Screen+Shot+2020-10-20+at+12.25.26+PM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209107637-FDSOSBXTE0FF53R5WA5T/ke17ZwdGBToddI8pDm48kMOEKR6dMCPy4fM9-VkAFQpZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpxOaa7bJC5nC-3Vx8_VvQU5ZHSi5EFCqkqDpHcCRO5IdflSV9hpbzW8q9sq3pWEROU/Screen+Shot+2020-10-20+at+11.51.01+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209273181-H1MG6JQO5C400ROPPYHC/ke17ZwdGBToddI8pDm48kDrMjE7hBq4fQV3wYHraitJZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyGCq5VpfeBJu-82OcOh-bqszTBJBXlZyh56jWduE-YAd2_jHuFGTcrhGEJySBGUHo/Screen+Shot+2020-10-20+at+11.53.09+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209367515-EFGPZ22X1ITJH8S81KGX/ke17ZwdGBToddI8pDm48kBhjaGRc9woxQsp0OESMfwNZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyngboOM180BszoBgc3fumCi_tcEB7kpB1QYLcJqR6kt4QKmzUY1LAfx_037DOA0w8/Screen+Shot+2020-10-20+at+11.55.40+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209430454-3BBG417O47EBIEYSTZ74/ke17ZwdGBToddI8pDm48kM8kgpbBhpuRIFgMPwjKfHZZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpyYj3FJCo-0TwancYhkFrKhbSnTsBk3FrdMBYolUAriybe62lzI7vM675NepYfXY0w/Screen+Shot+2020-10-20+at+11.56.56+AM.png?format=750w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209535664-LE9J2F5UJ9HPD7KJ0UJA/ke17ZwdGBToddI8pDm48kCiHm6FumI7xn1vYkvImj9ZZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVHDxKMe0ejUNARF_HkkTy2UGvJE6LDZplt4FfGLYEhAK91lH3P2bFZvTItROhWrBJ0/Screen+Shot+2020-10-20+at+11.58.41+AM.png?format=500w"),
    Image.network("https://images.squarespace-cdn.com/content/v1/5755a35501dbae3c6d1ba03e/1603209640186-7O4X5XNJXSZMFFEH0AIB/ke17ZwdGBToddI8pDm48kJCnqEJNa8cQx4dOK61i5M9Zw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVHutsJOOT2Y-AmV66IFlbAuCMhmZUNNPTGbVM5MYYp1-xur-lC0WofN0YB1wFg-ZW0/Screen+Shot+2020-10-20+at+12.00.23+PM.png?format=500w"),
    Image.network("https://static.billboard.com/files/media/The-Velvet-Underground-Nico-greatest-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/The-Beatles-Abbey-Road-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/Patti-Smith-Horses-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/Led-Zeppelin-Led-Zeppelin-greatest-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/Pink-Floyd-Dark-Side-of-the-Moon-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/Nirvana-Nevermind-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/Cyndi-Lauper-Shes-So-Unusual-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/The-Beatles-Sgt-Peppers-lonely-hearts-club-band-album-covers-billboard-1000x1000-compressed.jpg"),
    Image.network("https://static.billboard.com/files/media/To-pimp-a-butterfly-kendrick-lamar-no1-albums-billboard-1000x1000-compressed.jpg"),
  ];

  var rng = new Random();

  FocusNode artistFocusNode;
  FocusNode albumFocusNode;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
        return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: [
          Container(
            child: CarouselSlider.builder(
              itemCount: images.length,
              options: CarouselOptions(
                aspectRatio: 1,
                enlargeCenterPage: true,
                initialPage: rng.nextInt(images.length),
                viewportFraction: 1,
                autoPlay: true,
              ),
              itemBuilder: (ctx, index, realIdx) {
                return Container(
                  child: images[index],
                );
              },
            )
          ),
          SizedBox(height: 20,),
          TextField(
            focusNode: artistFocusNode,
            onChanged: (text) {
              setState(() {
                artist = text;
              });
            },
            onEditingComplete: () {
              node.nextFocus();
            },
            decoration: InputDecoration(
              labelText: "Artist",
              labelStyle: TextStyle(
                fontSize: 20
              ),
              suffixIcon: Icon(Icons.music_note_outlined)
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            onChanged: (text) {
              setState(() {
                album = text;  
              });
            },
            onSubmitted: (value) {
              print(value);
              if (artist != "") {
                getReview(artist, album);
              }
              else {
                node.unfocus();
              }
            },
            decoration: InputDecoration(
              labelText: "Album",
              labelStyle: TextStyle(
                fontSize: 20
              ),
              suffixIcon: Icon(Icons.library_music_rounded)
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
            onPressed: album == "" || artist == "" ? null : () => getReview(artist, album),
            child: Container(width: 100, height: 50, child: Center(child: Text("Search"))),
          )
        ],
        ),
      );
       },
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                data["artist"],
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 10),
              Text(
                data["album"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35
                ),
              ),
              SizedBox(height: 20),
              Image.network(data["cover"], scale: .1,),
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
            SizedBox(height: 10),
            Text("As more users search for reviews, there will be more to explore here.", 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20
            )),
            SizedBox(height: 20),
            for(var i = 0;i<genres.length; i++) GestureDetector(
              onTap: () {
                readDataDetail(genres[i]);
              },
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width-50,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(child: Text(genres[i], style: TextStyle(fontSize: 25, color: Colors.white)))
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
                decoration: BoxDecoration(
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
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
                decoration: BoxDecoration(
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
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
