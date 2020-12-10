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
void changeToHoursMatches() {
  hourListMatches = [...matchesRuntime];
  minutesListMatches = [];
  for (var j = 0; j < matchesRuntime.length; j++) {
    hourListMatches[j] = (hourListMatches[j] / 3600).toInt();
  }
  for (var i = 0; i < matchesRuntime.length; i++) {
    if (matchesRuntime[i] < 7200 && matchesRuntime[i] > 3600) {
      matchesRuntime[i] = matchesRuntime[i] - 3600;
      matchesRuntime[i] = matchesRuntime[i] ~/ 60;
      minutesListMatches.add(matchesRuntime[i]);
    } else if (matchesRuntime[i] < 3600) {
      matchesRuntime[i] = matchesRuntime[i] ~/ 60;

      minutesListMatches.add(matchesRuntime[i]);
    } else if (matchesRuntime[i] < 10800 && matchesRuntime[i] > 7200) {
      matchesRuntime[i] = matchesRuntime[i] - 7200;
      matchesRuntime[i] = matchesRuntime[i] ~/ 60;

      minutesListMatches.add(matchesRuntime[i]);
    } else {
      matchesRuntime[i] = matchesRuntime[i] - 10800;
      matchesRuntime[i] = matchesRuntime[i] ~/ 60;

      minutesListMatches.add(matchesRuntime[i]);
    }
  }
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
                matchesImage[current],
                scale: 0.55,
              ),
              Text('Title: ${matchesTitles[current]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 3.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Genre: ${matchesGenre[current]}',
                  style: TextStyle(
                      color: Colors.white,
                      height: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text(
                  'Runtime: ${hourListMatches[current]}h ${minutesListMatches[current]}m',
                  style: TextStyle(
                      color: Colors.white,
                      height: 2.0,
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
                    height: 2.0,
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
                  matchesGenre.remove(matchesGenre[current]),
                  matchesRuntime.remove(matchesRuntime[current]),
                  hourListMatches.remove(hourListMatches[current]),
                  minutesListMatches.remove(minutesListMatches[current]),
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
