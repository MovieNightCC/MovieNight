import 'package:flutter/material.dart';
import './swiper.dart';
import './profile.dart';
import './matches.dart';

class MatchInfo extends StatefulWidget {
  @override
  _MatchInfoState createState() => _MatchInfoState();
}

var count = 0;

class _MatchInfoState extends State<MatchInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
              Image.network(matchesImage[current]),
              // Image.network(movieImagesTest[count]),
              Text('Title: ${matchesTitles[current]}',
                  style: TextStyle(
                      height: 5.0, fontWeight: FontWeight.bold, fontSize: 20)),
              Text('Synopsis: ${matchesSynopsis[current]}',
                  style: TextStyle(
                      height: 1.5, fontWeight: FontWeight.bold, fontSize: 20)),
              Text(
                'Release Year: ${matchesYear[current]}',
                style: TextStyle(
                    height: 4.0, fontWeight: FontWeight.bold, fontSize: 20),
              )
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
    Paint paint = Paint()..color = Colors.pink[200];
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
