import 'dart:async';
import 'package:flutter/material.dart';
import './swiper.dart';
import './tinderCard.dart';
import './movieInfo.dart';
import 'dart:async';
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
  @override
  CardController controller;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rush Mode!',
            style: TextStyle(
                height: 1.5, fontWeight: FontWeight.bold, fontSize: 30)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.red[400],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            children: [
              TimerWidget(),
              Column(
                children: [
                  Center(
                    child: InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
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
                          swipeCompleteCallback:
                              (CardSwipeOrientation orientation, int index) {
                            if (orientation == CardSwipeOrientation.RIGHT) {
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
                              //when hated
                              print('you hate: ${movieDataTest[count]}');
                              count++;
                              print(chosenGenre);
                            }
                          },
                        ),
                      ),
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       new MaterialPageRoute(
                      //           builder: (context) => Info()));
                      // },
                    ),
                  ),
                ],
              ),
              // RaisedButton(
              //   onPressed: () => launch(
              //       'https://www.netflix.com/title/${movieDataTest[count]}'),
              //   child:
              //       const Text('Go to Netflix', style: TextStyle(fontSize: 20)),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.red[400];
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
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                        title: new Text("Alert"),
                        content: new Text("Time's Up!"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Go Back to Swiper!'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Swiper(),
                                      maintainState: true));
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          )
                        ],
                      ));

              _start = 10;
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_start",
            style: TextStyle(
                height: 1.5, fontWeight: FontWeight.bold, fontSize: 100)),
        RaisedButton(
          onPressed: () {
            startTimer();
          },
          child: Text("start"),
        ),
      ],
    );
  }
}
