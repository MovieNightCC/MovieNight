import 'package:flutter/material.dart';
import './swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

var count = 0;
List minutesList;
List hourList;
void changeToHours() {
  hourList = [...movieRuntime];
  minutesList = [];
  for (var j = 0; j < movieRuntime.length; j++) {
    hourList[j] = (hourList[j] / 3600).toInt();
  }
  for (var i = 0; i < movieRuntime.length; i++) {
    if (movieRuntime[i] < 7200 && movieRuntime[i] > 3600) {
      movieRuntime[i] = movieRuntime[i] - 3600;
      movieRuntime[i] = (movieRuntime[i] / 60).toInt();
      minutesList.add(movieRuntime[i]);
    } else if (movieRuntime[i] < 3600) {
      movieRuntime[i] = (movieRuntime[i] / 60).toInt();
      minutesList.add(movieRuntime[i]);
    } else {
      movieRuntime[i] = movieRuntime[i] - 7200;
      movieRuntime[i] = (movieRuntime[i] / 60).toInt();
      minutesList.add(movieRuntime[i]);
    }
  }
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Image.network(movieImagesTest[count]),
              ),
              Text('Title: ${movieTitles[count]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 3.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Genre: ${movieGenre[count]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 3.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Runtime: ${hourList[count]}h ${minutesList[count]}m',
                  style: TextStyle(
                      color: Colors.white,
                      height: 3.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Synopsis: ${moviesSynopsis[count]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                'Release Year: ${movieYear[count]}',
                style: TextStyle(
                    color: Colors.white,
                    height: 2.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              RaisedButton(
                onPressed: () => launch(
                    'https://www.netflix.com/title/${movieDataTest[count]}'),
                child:
                    const Text('Go to Netflix', style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Positioned(
                        left: 40,
                        bottom: 20,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            print('you hate: ${movieDataTest[count]}');
                            count++;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Swiper(),
                                  maintainState: true,
                                ));
                          },
                          tooltip: 'Increment',
                          child: Icon(Icons.sentiment_very_dissatisfied),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.red[900],
                        ),
                      ),
                      Positioned(
                        right: 80,
                        bottom: 20,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            print('you liked: ${movieDataTest[count]}');

                            //request to firebase server to update likes
                            updateUser(
                                movieDataTest[count],
                                context,
                                movieImagesTest[count],
                                movieTitles[count],
                                movieYear[count],
                                moviesSynopsis[count],
                                movieGenre[count],
                                movieRuntime[count]);
                            count++;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Swiper(),
                                  maintainState: true,
                                ));
                          },
                          tooltip: 'Increment',
                          child: Icon(Icons.sentiment_very_satisfied),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ]),
              ),
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
