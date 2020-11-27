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
  Future<Response> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovie();
  }

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

List<String> movieDataTest = [];
List<String> movieImagesTest = [];

Future<Response> fetchMovie() async {
  final response = await Dio().get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
  if (response.statusCode == 200) {
    var movies = response.data;
    for (var i = 0; i < movies.length; i++) {
      movieDataTest.add(movies[i]["title"]);
      movieImagesTest.add(movies[i]["img"]);
    }
    return response;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Tinderswiper extends StatefulWidget {
  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

  List shuffle(List listA, List listB) {
    var random = new Random();

    // Go through all elements.
    for (var i = listA.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = listA[i];
      var temp2 = listB[i];
      listA[i] = listA[n];
      listB[i] = listB[n];
      listA[n] = temp;
      listB[n] = temp2;
    }

    return listA;
  }

  @override
  Widget build(BuildContext context) {
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
          child: FutureBuilder<Response>(
            future: fetchMovie(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                shuffle(movieDataTest, movieImagesTest);
                return Center(
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
                              movieImagesTest[index],
                              fit: BoxFit.fill,
                            )),
                        elevation: 10.0,
                      ),
                      cardController: controller = CardController(),
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        if (orientation == CardSwipeOrientation.RIGHT) {
                          //when liked
                          print('you liked: ${movieDataTest[index]}');
                        } else if (orientation == CardSwipeOrientation.LEFT) {
                          print('you hate: ${movieDataTest[index]}');
                        }
                      },
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
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
