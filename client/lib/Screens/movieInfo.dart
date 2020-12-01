import 'package:flutter/material.dart';
import './swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

var count = 0;

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
              // Image.network(movieImagesTest[count]),
              Text('Title: ${movieTitles[count]}',
                  style: TextStyle(
                      height: 5.0, fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Synopsis: ${moviesSynopsis[count]}',
                  style: TextStyle(
                      height: 1.5, fontWeight: FontWeight.bold, fontSize: 20)),
              Text(
                'Release Year: ${movieYear[count]}',
                style: TextStyle(
                    height: 4.0, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              RaisedButton(
                onPressed: () => launch(
                    'https://www.netflix.com/title/${movieDataTest[count]}'),
                child:
                    const Text('Go to Netflix', style: TextStyle(fontSize: 20)),
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
