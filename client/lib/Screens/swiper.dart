import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movie_night/app-theme.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import '../main.dart';
import './rush_two.dart';
import './tinderCard.dart';
import './matches.dart';
import './profile.dart';
import './movieInfo.dart';
import './movieArray.dart';
//import './rushMode.dart';
import './filterPopup.dart';
import './movieMatchesInfo.dart';

import 'package:http/http.dart' as http;

var swipeLeftOpacity = 0.0;
var swipeRightOpacity = 0.0;

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
  Future<Response> futureMovie;

  void showLeftCue() {
    setState(() => swipeLeftOpacity = 1);
  }

  void showRightCue() {
    setState(() => swipeRightOpacity = 1);
  }

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
      theme: _kShrineTheme,
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

void reverseList() {
  matchesTitles = matchesTitles.reversed.toList();
  matchesImage = matchesImage.reversed.toList();
  matchesYear = matchesYear.reversed.toList();
  matchesGenre = matchesGenre.reversed.toList();
  matchesRuntime = matchesRuntime.reversed.toList();
  matchesSynopsis = matchesSynopsis.reversed.toList();
  matchesNfid = matchesNfid.reversed.toList();
  hourListMatches = hourListMatches.reversed.toList();
  minutesListMatches = minutesListMatches.reversed.toList();
  reversedCalled = true;
}

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
              title: new Text("Alert", style: TextStyle(color: Colors.black)),
              content: new Text("You got a Match!",
                  style: TextStyle(color: Colors.black)),
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
  var swipeLeftOpacity = 0.0;
  var swipeRightOpacity = 0.0;

  void setLeftCue(input) {
    setState(() => swipeLeftOpacity = input);
  }

  void setRightCue(input) {
    setState(() => swipeRightOpacity = input);
  }

  @override
  Widget build(BuildContext context) {
    if (reversedCalled == false) {
      reverseList();
    }
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
                        stackNum: 10,
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
                        swipeUpdateCallback:
                            (DragUpdateDetails details, Alignment align) {
                          /// Get swiping card's alignment
                          print(align.x);
                          if (align.x > -2.0 && align.x < 2.0) {
                            setLeftCue(0.0);
                            setRightCue(0.0);
                            print("should not show");
                          } else if (align.x <= -5) {
                            setLeftCue(1.0);
                          } else if (align.x <= -2) {
                            setLeftCue(0.5);
                          } else if (align.x >= 5) {
                            setRightCue(1.0);
                          } else if (align.x >= 2) {
                            setRightCue(0.5);
                            print("should show FULL THING");
                          }
                        },
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          if (orientation == CardSwipeOrientation.RIGHT) {
                            //when liked
                            print('you liked: ${movieDataTest[count]}');
                            setLeftCue(0.0);
                            setRightCue(0.0);
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
                          } else if (orientation == CardSwipeOrientation.LEFT) {
                            setLeftCue(0.0);
                            setRightCue(0.0);
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
              //swipe cue dislike
              left: 40,
              bottom: 250,
              child: Opacity(
                opacity: swipeLeftOpacity,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: null,
                  onPressed: () {
                    print("pressed");
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.thumb_down, size: 50),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              )),
          Positioned(
              //swipe cue dislike
              right: 40,
              bottom: 250,
              child: Opacity(
                opacity: swipeRightOpacity,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: null,
                  onPressed: () {
                    print("pressed");
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.thumb_up, size: 50),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              )),
          Positioned(
            left: 80,
            bottom: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: null,
              onPressed: () {
                print('pressed');
                joinRush();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RushTwo(),
                      maintainState: true,
                    ));
              },
              tooltip: 'Go to Rush Mode',
              child: Icon(Icons.fast_forward, size: 40),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Positioned(
            right: 80,
            bottom: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.yellow,
              heroTag: null,
              onPressed: () => filterPop(context),
              tooltip: 'Filter Movies',
              child: Icon(Icons.settings, size: 40),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.pink,
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
    Paint paint = Paint()..color = Colors.pink;
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

final ThemeData _kShrineTheme = _buildShrineTheme();
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.pink,
      accentColor: Colors.white,
      accentColorBrightness: Brightness.dark,
      canvasColor: Color(0xfffafafa),
      scaffoldBackgroundColor: Colors.black,
      bottomAppBarColor: Colors.white,
      cardColor: Colors.black,
      dividerColor: Colors.grey,
      highlightColor: Color(0x66bcbcbc),
      splashColor: Color(0x66c8c8c8),
      selectedRowColor: Color(0xfff5f5f5),
      unselectedWidgetColor: Color(0x8a000000),
      disabledColor: Color(0x61000000),
      buttonColor: Colors.orange,
      toggleableActiveColor: Color(0xffd81b60),
      secondaryHeaderColor: Color(0xfffce4ec),
      textSelectionColor: Color(0xfff48fb1),
      cursorColor: Colors.pink,
      textSelectionHandleColor: Color(0xfff06292),
      backgroundColor: Color(0xfff48fb1),
      dialogBackgroundColor: Colors.pink,
      indicatorColor: Color(0xffe91e63),
      hintColor: Colors.pinkAccent,
      errorColor: Colors.purple[900],
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          minWidth: 88,
          height: 36,
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.pink,
              width: 1,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          )));
}

void joinRush() async {
  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/joinRush?userName=$userName&pairName=$userPair");
  print(response.body);
}
