import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:neon/neon.dart';
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

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
  Future<Response> futureMovie;

  @override
  void initState() {
    super.initState();
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

void updateUser(
    // arrOfNfid, context, image, title, year, synopsis, genre, runtime
    arrOfNfid,
    context,
    genre) async {
  print(userName);
  print('$arrOfNfid');
  print('$genre');

  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/updateUserLikes?userName=$userName&movieArr=[$arrOfNfid]&genre=$genre");
  print(response.body);
  if (response.body == "match!") {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Alert", style: TextStyle(color: Colors.white)),
              content: new Text("You got a Match!",
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                FlatButton(
                  child:
                      Text('Close me!', style: TextStyle(color: Colors.pink)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
  }
}

class Tinderswiper extends StatefulWidget {
  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  int _currentIndex = 1;
  var _swipeLeftOpacity = 0.0;
  var _swipeRightOpacity = 0.0;

  void _setLeftCue(input) {
    setState(() => _swipeLeftOpacity = input);
  }

  void _setRightCue(input) {
    setState(() => _swipeRightOpacity = input);
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
          Positioned(
              top: 25,
              child: Neon(
                text: 'Movie Night',
                color: Colors.pink,
                fontSize: 35,
                font: NeonFont.Membra,
                flickeringText: false,
              )),
//               - Automania
// - Beon
// - Cyberpunk
// - LasEnter
// - Membra
// - Monoton
// - Night-Club-70s
// - Samarin
// - TextMeOne
          Image.asset("./assets/icons/loadingCool.gif"),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              children: [
                Center(
                  heightFactor: 1.1,
                  child: InkWell(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: TinderSwapCard(
                        orientation: AmassOrientation.TOP,
                        totalNum: 100,
                        stackNum: 10,
                        swipeEdge: 5.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        maxHeight: MediaQuery.of(context).size.width * 1.75,
                        minWidth: MediaQuery.of(context).size.width * 0.899,
                        minHeight: MediaQuery.of(context).size.width * 1.7499,
                        cardBuilder: (context, index) {
                          return Card(
                            color: Color(0x00000000),
                            child: Container(
                              // padding: EdgeInsets.all(20.0),

                              child: Image.network(
                                movieImagesTest[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                            elevation: 0,
                          );
                        },
                        cardController: controller = CardController(),
                        swipeUpdateCallback:
                            (DragUpdateDetails details, Alignment align) {
                          /// Get swiping card's alignment
                          if (align.x > -2.0 && align.x < 2.0) {
                            _setLeftCue(0.0);
                            _setRightCue(0.0);
                            print("should not show");
                          } else if (align.x <= -5) {
                            _setLeftCue(1.0);
                          } else if (align.x <= -2) {
                            _setLeftCue(0.5);
                          } else if (align.x >= 5) {
                            _setRightCue(1.0);
                          } else if (align.x >= 2) {
                            _setRightCue(0.5);
                            print("should show FULL THING");
                          }
                        },
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          if (orientation == CardSwipeOrientation.RIGHT) {
                            //when liked
                            print('you liked: ${movieDataTest[count]}');
                            _setLeftCue(0.0);
                            _setRightCue(0.0);
                            //request to firebase server to update likes
                            if (userPair != "") {
                              updateUser(
                                movieDataTest[count],
                                context,
                                // movieImagesTest[count],
                                // movieTitles[count],
                                // movieYear[count],
                                // moviesSynopsis[count],
                                movieGenre[count],
                                // movieRuntime[count]
                              );
                            }

                            count++;
                          } else if (orientation == CardSwipeOrientation.LEFT) {
                            _setLeftCue(0.0);
                            _setRightCue(0.0);
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
              left: 10,
              bottom: 320,
              child: Opacity(
                opacity: _swipeLeftOpacity,
                child: FloatingActionButton(
                  backgroundColor: Colors.red[500],
                  heroTag: null,
                  onPressed: () {
                    print("pressed");
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.cancel_outlined, size: 50),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              )),
          Positioned(
              //swipe cue like
              right: 10,
              bottom: 320,
              child: Opacity(
                opacity: _swipeRightOpacity,
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  heroTag: null,
                  onPressed: () {
                    print("pressed");
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.check, size: 50),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              )),
          Positioned(
            left: 80,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent[700],
              heroTag: null,
              onPressed: () {
                joinRush();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RushTwo(),
                      maintainState: true,
                    ));
              },
              tooltip: 'Go to Rush Mode',
              child: Icon(Icons.fast_forward, size: 40, color: Colors.white),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Positioned(
            right: 80,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.deepPurple[300],
              heroTag: null,
              onPressed: () => filterPop(context),
              tooltip: 'Filter Movies',
              child: Icon(Icons.settings, size: 40, color: Colors.white),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff412DB3),
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
    Paint paint = Paint()..color = Color(0xff412DB3);
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
