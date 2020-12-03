import 'package:flutter/material.dart';
import 'package:flutterPractice/main.dart';
import './matches.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class MatchInfo extends StatefulWidget {
  @override
  _MatchInfoState createState() => _MatchInfoState();
}

void deleteMatch(nfid) async {
  print(nfid);
  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/deleteMatch?pairName=testPairA&nfid=$nfid");

  print(response.body);
}

class _MatchInfoState extends State<MatchInfo> {
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
              Image.network(matchesImage[current]),
              Text('Title: ${matchesTitles[current]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 5.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Synopsis: ${matchesSynopsis[current]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                'Release Year: ${matchesYear[current]}',
                style: TextStyle(
                    color: Colors.white,
                    height: 4.0,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ), //matchesNfid,
              RaisedButton(
                onPressed: () => launch(
                    'https://www.netflix.com/title/${matchesNfid[current]}'),
                child:
                    const Text('Go to Netflix', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                color: Colors.red[900],
                onPressed: () => {
                  deleteMatch(matchesNfid[current]),
                  matchesTitles.remove(matchesTitles[current]),
                  matchesSynopsis.remove(matchesSynopsis[current]),
                  matchesImage.remove(matchesImage[current]),
                  matchesYear.remove(matchesYear[current]),
                  matchesNfid.remove(matchesNfid[current]),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Matches(), maintainState: true))
                },
                child: const Text('Remove from Matches',
                    style: TextStyle(fontSize: 20)),
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
