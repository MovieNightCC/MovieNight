import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movie_night/app-theme.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

import '../main.dart';

import './tinderCard.dart';
import './matches.dart';
import './profile.dart';
import './movieInfo.dart';
import './movieArray.dart';
import './rushMode.dart';
import './filterPopup.dart';
import './movieMatchesInfo.dart';

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
  Future<Response> futureMovie;

  @override
  void initState() {
    super.initState();
    print("fetchArr $fetchArr");
    if (fetchArr.length > 1 && cutInHalfCalled == false) {
      cutInHalf();
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Night",
      debugShowCheckedModeBanner: false,
      theme: movieNightTheme,
      home: Tinderswiper(),
    );
  }
}

List<Object> moviesList = [];
List<int> movieDataTest = [];
List<String> movieImagesTest = [];
List<String> movieTitles = [];
List<String> moviesSynopsis = [];
List<String> movieGenre = [];
List<int> movieYear = [];
List<int> movieRuntime = [];
var counter = 0;

void cutInHalf() {
  cutInHalfCalled = true;
  print('cutinhalf is called');
  print('matchorilength is $matchOriLength');
  int halfLength = matchesTitles.length ~/ 2;
  matchesTitles = matchesTitles.sublist(0, halfLength);
  matchesImage = matchesImage.sublist(0, halfLength);
  matchesYear = matchesYear.sublist(0, halfLength);
  matchesGenre = matchesGenre.sublist(0, halfLength);
  matchesRuntime = matchesRuntime.sublist(0, halfLength);
  matchesSynopsis = matchesSynopsis.sublist(0, halfLength);
  matchesNfid = matchesNfid.sublist(0, halfLength);

  matchesTitles = matchesTitles.reversed.toList();
  matchesImage = matchesImage.reversed.toList();
  matchesYear = matchesYear.reversed.toList();
  matchesGenre = matchesGenre.reversed.toList();
  matchesRuntime = matchesRuntime.reversed.toList();
  matchesSynopsis = matchesSynopsis.reversed.toList();
  matchesNfid = matchesNfid.reversed.toList();
}

void makeHour() {
  hourListMatches[0] = (hourListMatches[0] / 3600).toInt();
  if (matchesRuntime[0] < 7200 && matchesRuntime[0] > 3600) {
    matchesRuntime[0] = matchesRuntime[0] - 3600;
    matchesRuntime[0] = matchesRuntime[0] ~/ 60;

    minutesListMatches.add(matchesRuntime[0]);
  } else if (matchesRuntime[0] < 3600) {
    matchesRuntime[0] = matchesRuntime[0] ~/ 60;
    minutesListMatches.add(matchesRuntime[0]);
  } else {
    matchesRuntime[0] = matchesRuntime[0] - 7200;
    matchesRuntime[0] = matchesRuntime[0] ~/ 60;
    minutesListMatches.add(matchesRuntime[0]);
  }
}

void updateUser(
    arrOfNfid, context, image, title, year, synopsis, genre, runtime) async {
  print(userName);
  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/updateUserLikes?userName=$userName&movieArr=[$arrOfNfid]&genre=$genre");
  print(response.body);
  if (response.body == "match!") {
    //push to matches array
    print("old list $matchesTitles");
    matchesTitles.insert(0, title);
    matchesSynopsis.insert(0, synopsis);
    matchesImage.insert(0, image);
    matchesYear.insert(0, year);
    matchesRuntime.insert(0, runtime);
    hourListMatches.insert(0, runtime);
    matchesNfid.insert(0, arrOfNfid);
    matchesGenre.insert(0, genre);
    print("new match nfid $matchesNfid");
    print("new list $matchesTitles");

    print("new list $matchesTitles");
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Alert"),
              content: new Text("You got a Match!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
    makeHour();
  }
}

class Tinderswiper extends StatefulWidget {
  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

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
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: TinderSwapCard(
                        orientation: AmassOrientation.TOP,
                        totalNum: 100,
                        stackNum: 2,
                        swipeEdge: 5.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        maxHeight: MediaQuery.of(context).size.width * 1.6,
                        minWidth: MediaQuery.of(context).size.width * 0.899,
                        minHeight: MediaQuery.of(context).size.width * 1.599,
                        cardBuilder: (context, index) {
                          return Card(
                            child: Container(
                                // padding: EdgeInsets.all(20.0),
                                child: Image.network(
                              movieImagesTest[index],
                              fit: BoxFit.fill,
                            )),
                            elevation: 0,
                          );
                        },
                        cardController: controller = CardController(),
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          if (orientation == CardSwipeOrientation.RIGHT) {
                            //when liked
                            print('you liked: ${movieDataTest[count]}');

                            //request to firebase server to update likes
                            if (userPair != "") {
                              updateUser(
                                  movieDataTest[count],
                                  context,
                                  movieImagesTest[count],
                                  movieTitles[count],
                                  movieYear[count],
                                  moviesSynopsis[count],
                                  movieGenre[count],
                                  movieRuntime[count]);
                            }

                            count++;
                            // print(movieDataTest[index].runtimeType);

                            //  (?userName=<userName>&movieArr=<An Array of netflix IDs>)
                            // response = await dio.post("/test", data: {"id": 12, "name": "wendu"});

                          } else if (orientation == CardSwipeOrientation.LEFT) {
                            //when hated
                            print('you hate: ${movieDataTest[count]}');
                            count++;
                          }
                        },
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => Info()));
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 80,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                print('pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RushMode(),
                      maintainState: true,
                    ));
              },
              tooltip: 'Increment',
              child: Icon(Icons.flash_on_sharp),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.red[400],
            ),
          ),
          Positioned(
            right: 80,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () => filterPop(context),
              tooltip: 'Increment',
              child: Icon(Icons.swap_calls, size: 40),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.blue[200],
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
        ));
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
