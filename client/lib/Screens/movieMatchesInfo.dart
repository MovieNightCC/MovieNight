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
  String twoDigits(int n) => n.toString().padLeft(2, "0");
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
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          ListView(
            padding: const EdgeInsets.all(50),
            children: [
              Image.network(
                matchesMovieData[current]['img'],
                scale: 0.55,
              ),
              Text(
                  'Title: ${matchesMovieData[current]['title'].replaceAll('&#39;', "'")}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 3.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Genre: ${matchesMovieData[current]['genre']}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                  'Runtime: ${printDuration(Duration(seconds: matchesMovieData[current]['runtime']))}',
                  // 'Runtime: ${hourListMatches[current]}h ${minutesListMatches[current]}m',
                  style: TextStyle(
                      color: Colors.white,
                      height: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                  'Synopsis: ${matchesMovieData[current]['synopsis'].replaceAll('&#39;', "'")}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                'Release Year: ${matchesMovieData[current]['year']}',
                style: TextStyle(
                    color: Colors.white,
                    height: 2.0,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ), //matchesNfid,
              RaisedButton(
                color: Colors.red[900],
                onPressed: () => launch(
                    'https://www.netflix.com/title/${matchesMovieData[current]['nfid']}'),
                child:
                    const Text('Go to Netflix', style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                color: Colors.deepPurple,
                onPressed: () => {
                  deleteMatch(matchesMovieData[current]['nfid']),
                  // matchesTitles.remove(matchesTitles[current]),
                  // matchesSynopsis.remove(matchesSynopsis[current]),
                  // matchesImage.remove(matchesImage[current]),
                  // matchesYear.remove(matchesYear[current]),
                  // matchesGenre.remove(matchesGenre[current]),
                  // matchesRuntime.remove(matchesRuntime[current]),
                  // hourListMatches.remove(hourListMatches[current]),
                  // minutesListMatches.remove(minutesListMatches[current]),
                  // matchesNfid.remove(matchesNfid[current]),
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
