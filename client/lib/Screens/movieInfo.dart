import 'package:flutter/material.dart';
import './swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString();
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

var count = 0;
List minutesList;
List hourList;

class _InfoState extends State<Info> {
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
    print('this movie runtime ${movieRuntime[count]}');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.22,
            child: Image.network(movieImagesTest[count],
                height: MediaQuery.of(context).size.height * 0.85,
                // width: 100,
                fit: BoxFit.fitWidth),
          ),
          ListView(
            padding: const EdgeInsets.all(35),
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 20),
                  child: Text('${movieTitles[count]}',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          height: 1.5,
                          // fontWeight: FontWeight.bold,
                          fontSize: 35))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: Text('${moviesSynopsis[count]}',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          height: 1.5,
                          // fontWeight: FontWeight.bold,
                          fontSize: 17))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text('Genre: ${movieGenre[count]}',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          height: 1.5,
                          // fontWeight: FontWeight.bold,
                          fontSize: 15))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                      'Runtime: ${printDuration(Duration(seconds: movieRuntime[count]))}',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          height: 1.5,
                          // fontWeight: FontWeight.bold,
                          fontSize: 15))),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Text(
                  'Release Year: ${movieYear[count]}',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: 'Open Sans',
                      height: 1.5,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Positioned(
                        left: 40,
                        bottom: 20,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            _setLeftCue(1.0);
                            print('you hate: ${movieDataTest[count]}');
                            Future.delayed(Duration(milliseconds: 300), () {
                              // 5s over, navigate to a new page
                              count++;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Swiper()));
                            });
                          },
                          tooltip: 'Do not want to watch',
                          child: Icon(Icons.cancel_outlined),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          backgroundColor: Colors.red[900],
                        ),
                      ),
                      Positioned(
                        right: 80,
                        bottom: 20,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            _setRightCue(1.0);
                            print('you liked: ${movieDataTest[count]}');

                            //request to firebase server to update likes
                            updateUser(
                              movieDataTest[count],
                              context,
                              movieGenre[count],
                            );
                            Future.delayed(Duration(milliseconds: 300), () {
                              // 5s over, navigate to a new page
                              count++;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Swiper()));
                            });
                          },
                          tooltip: 'Want to watch',
                          child: Icon(Icons.check),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ]),
              ),
              RaisedButton(
                color: Colors.red[900],
                onPressed: () => launch(
                    'https://www.netflix.com/title/${movieDataTest[count]}'),
                child: const Text('Go to Netflix',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                    )),
              ),
            ],
          ),
          Positioned(
              //swipe cue dislike
              left: 100,
              bottom: 250,
              child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: _swipeLeftOpacity,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: FloatingActionButton(
                      backgroundColor: Colors.red[900],
                      heroTag: null,
                      onPressed: () {},
                      tooltip: 'Increment',
                      child: Icon(Icons.cancel_outlined, size: 50),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ))),
          Positioned(
              //swipe cue dislike
              right: 100,
              bottom: 250,
              child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: _swipeRightOpacity,
                  child: Container(
                    height: 200,
                    width: 200,
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
                  ))),
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
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
