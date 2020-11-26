import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:dio/dio.dart';
import './matches.dart';
import './profile.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
  // Future<Movie> futureMovie;

  // @override
  // void initState() {
  //   super.initState();
  //   futureMovie = fetchMovie();
  // }

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

// Future<Movie> fetchMovie() async {
//   final response = await http.get(
//       "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Movie.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

// class Movie {
//   final String avgrating;
//   final String img;
//   final String poster;
//   final int nfid;
//   final String title;
//   final int year;
//   final String synopsis;

//   Movie(
//       {this.avgrating,
//       this.img,
//       this.poster,
//       this.nfid,
//       this.title,
//       this.year,
//       this.synopsis});

//   factory Movie.fromJson(Map<String, dynamic> json) {
//     return Movie(
//       avgrating: json['avgrating'],
//       img: json['img'],
//       poster: json['poster'],
//       nfid: json['nfid'],
//       title: json['title'],
//       year: json['year'],
//       synopsis: json['synopsis'],
//     );
//   }
// }

// void getHttp() async {
//   try {
//     Response response = await Dio().get(
//         "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
//     var movies = response.data;
//     for (var i = 0; i < movies.length; i++) {
//       movieData.add(movies[i]["title"]);
//       movieImages.add(movies[i]["img"]);
//     }
//   } catch (e) {
//     print(e);
//   }
// }

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

  List<String> movieData = [
    "Kiss the Ground",
    "Sky Tour: The Movie",
    "Hello Carbot The Movie: Save The Moon"
  ];

  void getHttp() async {
    try {
      Response response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        movieData.add(movies[i]["title"]);
        movieImages.add(movies[i]["img"]);
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
    CardController controller;
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          painter: HeaderCurvedContainer(),
        ),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: TinderSwapCard(
              orientation: AmassOrientation.TOP,
              totalNum: 100,
              stackNum: 3,
              swipeEdge: 5.0,
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
              cardController: controller = CardController(),
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                if (orientation == CardSwipeOrientation.RIGHT) {
                  //when liked
                  print('you liked: ${movieData[index]}');
                } else if (orientation == CardSwipeOrientation.LEFT) {
                  print('you hate: ${movieData[index]}');
                }
              },
            ),
          ),
        ),
      ]),
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
                  builder: (context) => Profile(),
                  maintainState: true,
                ));
          }
        },
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.purple[200];
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
