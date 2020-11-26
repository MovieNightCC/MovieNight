import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:dio/dio.dart';
import './matches.dart';
import './profile.dart';
import 'dart:math';

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Night",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: Tinderswiper(),
    );
  }
}

class Tinderswiper extends StatefulWidget {
  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

  List<String> movieImages = [
    "https://occ-0-2851-1432.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABYo08D3k24uEHYsBSuX5CguS0M2I0zrgWmDZxNH0vFlQfVpg_eVvg17agekWnzdboqg-oqoK8R1Aptc0HxkI9EnKSA.jpg?r=b9e",
    "https://occ-0-2851-1432.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABf0YHTcQ5ZbfdAYXGRs4xVxuhI5K0mmWGqkxtC1V6W712RsYMckydjZ5HT0F7sADOEuRuGWcgp9EJeHyNQRco1hJOQ.jpg?r=884",
    "https://occ-0-1007-1360.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABfbHqmRyebWamsZa28nK6QrHR5tS3cwd0Pb0nXFMi5MF9luHk0zqViLI8DmzX6SLdHDGvuqLW53uN3V2GG1PMC2xAw.jpg?r=947",
  ];

  void getHttp() async {
    try {
      Response response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
      var pics = response.data;
      for (var i = 0; i < pics.length; i++) {
        movieImages.add(pics[i]["img"]);
      }
    } catch (e) {
      print(e);
    }
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    getHttp();
    // shuffle(movieImages);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, new MaterialPageRoute(builder: (context) => Matches()));
      //   },
      // ),
      // appBar: AppBar(
      //   title: Text("Swipe Movies"),
      // ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: 100,
            stackNum: 3,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 2.0,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Card(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Image.network(
                    movieImages[index],
                    fit: BoxFit.fill,
                  )),
              elevation: 10.0,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple[200],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_movies_outlined), label: 'Swipe'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: 'Matches'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Matches(), maintainState: true));
          }
          if (_currentIndex == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(), maintainState: true));
          }
        },
      ),
    );
  }
}
