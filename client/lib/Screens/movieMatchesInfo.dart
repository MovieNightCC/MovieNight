import 'package:flutter/material.dart';
import '../main.dart';
import './movieArray.dart';
import './matches.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MatchInfo extends StatefulWidget {
  @override
  _MatchInfoState createState() => _MatchInfoState();
}

void deleteMatch(nfid) async {
  print(nfid);
  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/deleteMatch?pairName=$userPair&nfid=$nfid");
  print(response.body);
}

List minutesListMatches;
List hourListMatches;

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString();
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}

class _MatchInfoState extends State<MatchInfo> {
  @override
  Widget build(BuildContext context) {
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
            opacity: 0.2,
            child: Image.network(matchesMovieData[current]['img'],
                height: MediaQuery.of(context).size.height * 1.0,
                // width: 100,
                fit: BoxFit.fitWidth),
          ),
          ListView(
            padding: const EdgeInsets.all(50),
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 20),
                  child: Text(
                      '${matchesMovieData[current]['title'].replaceAll('&#39;', "'")}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Open Sans',
                          fontSize: 35))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: Text(
                      '${matchesMovieData[current]['synopsis'].replaceAll('&#39;', "'")}',
                      style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w300,
                          //fontWeight:// FontWeight.bold,
                          fontFamily: 'Open Sans',
                          fontSize: 17))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                  child: Text('Genre: ${matchesMovieData[current]['genre']}',
                      style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w300,

                          // fontWeight: FontWeight.bold,
                          fontFamily: 'Open Sans',
                          fontSize: 15))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                  child: Text(
                      'Runtime: ${printDuration(Duration(seconds: matchesMovieData[current]['runtime']))}',
                      style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w300,

                          // fontWeight: FontWeight.bold,
                          fontFamily: 'Open Sans',
                          fontSize: 15))),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: Text(
                  'Release Year: ${matchesMovieData[current]['year']}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
              ),
              RaisedButton(
                color: Colors.red[900],
                onPressed: () => launch(
                    'https://www.netflix.com/title/${matchesMovieData[current]['nfid']}'),
                child: const Text('Go to Netflix',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,

                      // fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                    )),
              ),
              RaisedButton(
                color: Colors.deepPurple,
                onPressed: () => {
                  deleteMatch(matchesMovieData[current]['nfid']),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Matches(), maintainState: true))
                },
                child: const Text('Delete',
                    style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300,

                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans',
                    )),
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
