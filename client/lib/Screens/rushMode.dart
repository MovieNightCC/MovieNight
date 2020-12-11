import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import './swiper.dart';
import './tinderCard.dart';
import './movieInfo.dart';
import './filterPopup.dart';

//https://www.netflix.com/title/80191740?preventIntent=true
//https://www.netflix.com/jp-en/title/70080038?preventIntent=true
List<Object> rushModeList = [];
List<int> rushModeNfid = [];
List<String> rushModeImages = [];
List<String> rushModeTitles = [];
List<String> rushModeSynopsis = [];
List<String> rushModeGenre = [];
List<int> rushModeYear = [];
List<int> rushModeRuntime = [];

class RushMode extends StatefulWidget {
  @override
  _RushModeState createState() => _RushModeState();
}

class _RushModeState extends State<RushMode> {
  var _swipeLeftOpacity = 0.0;
  var _swipeRightOpacity = 0.0;

  void _setLeftCue(input) {
    setState(() => _swipeLeftOpacity = input);
  }

  void _setRightCue(input) {
    setState(() => _swipeRightOpacity = input);
  }

  @override
  CardController controller;
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Swiper(), maintainState: true));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Rush Mode!',
            style: TextStyle(
                height: 1.5, fontWeight: FontWeight.bold, fontSize: 30)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: _HeaderCurvedContainer(),
          ),
          Text("Loading...", style: TextStyle(fontSize: 40)),
          Column(
            children: [
              TimerWidget(),
              Column(
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
                            print('index is $index');
                            return Card(
                              color: Color(0x00000000),
                              child: Container(
                                  // padding: EdgeInsets.all(20.0),
                                  child: Image.network(
                                rushModeImages[index],
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
                              _setLeftCue(0.0);
                              _setRightCue(0.0);
                              //when liked
                              print('you liked: ${movieDataTest[count]}');

                              //request to firebase server to update likes
                              updateUser(
                                  rushModeNfid[count],
                                  context,
                                  rushModeImages[count],
                                  rushModeTitles[count],
                                  rushModeYear[count],
                                  rushModeSynopsis[count],
                                  rushModeGenre[count],
                                  rushModeRuntime[count]);
                              count++;
                              // print(movieDataTest[index].runtimeType);

                              //  (?userName=<userName>&movieArr=<An Array of netflix IDs>)
                              // response = await dio.post("/test", data: {"id": 12, "name": "wendu"});

                            } else if (orientation ==
                                CardSwipeOrientation.LEFT) {
                              _setLeftCue(0.0);
                              _setRightCue(0.0);
                              //when hated
                              print('you hate: ${movieDataTest[count]}');
                              count++;
                              print(chosenGenre);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              //swipe cue dislike
              left: 40,
              bottom: 350,
              child: Opacity(
                opacity: _swipeLeftOpacity,
                child: FloatingActionButton(
                  backgroundColor: Colors.red[900],
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
              //swipe cue dislike
              right: 40,
              bottom: 350,
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
        ],
      ),
    );
  }
}

class _HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.pink;
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 200, size.width, 100)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TimerWidget extends StatefulWidget {
  State createState() => new _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer _timer;
  int _start = 10;

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (mounted) {
          setState(() {
            if (_start < 1) {
              endRush();
              dispose();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Swiper(), maintainState: true));
              _start = 3;
            } else {
              _start = _start - 1;
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_start",
            style: TextStyle(
                height: 1.5, fontWeight: FontWeight.bold, fontSize: 100)),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rushPlus')
                .doc(userPair)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              //print("ICON ONE" + snapshot.data["iconOne"]);
              var playerOneJoined = snapshot.data["playerOneJoined"];
              var playerTwoJoined = snapshot.data["playerTwoJoined"];

              if (!snapshot.hasData) {
                return LinearProgressIndicator();
              } else if (playerOneJoined && playerTwoJoined) {
                startTimer();
                return Container(
                  width: 0,
                  height: 0,
                );
              }
            }),
      ],
    );
  }
}

void endRush() async {
  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/endGame?pairName=$userPair");
  print(response.body);
}
