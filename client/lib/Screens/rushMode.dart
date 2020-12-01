import 'dart:async';

import 'package:flutter/material.dart';
import './swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class RushMode extends StatefulWidget {
  @override
  _RushModeState createState() => _RushModeState();
}

class _RushModeState extends State<RushMode> {
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
          //movieDataTest[count]
          Column(
            children: [
              TimerWidget(),
              //Image.network(movieImagesTest[count]),
              // Image.network(movieImagesTest[count]),
              Text('Title:',
                  style: TextStyle(
                      height: 5.0, fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Synopsis:',
                  style: TextStyle(
                      height: 1.5, fontWeight: FontWeight.bold, fontSize: 20)),
              Text(
                'Release Year:',
                style: TextStyle(
                    height: 4.0, fontWeight: FontWeight.bold, fontSize: 20),
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
  int _start = 30;

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
        RaisedButton(
          onPressed: () {
            startTimer();
          },
          child: Text("start"),
        ),
        Text(
          "$_start",
        )
      ],
    );
  }
}
