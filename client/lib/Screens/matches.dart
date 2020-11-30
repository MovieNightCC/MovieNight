import 'package:flutter/material.dart';
import './swiper.dart';
import './profile.dart';
import './movieMatchesInfo.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

var current = 0;

List<Object> matches = [];
List<String> matchesTitles = [];
List<String> matchesSynopsis = [];
List<String> matchesImage = [];
List<int> matchesYear = [];
List<int> matchesNfid = [];

class _MatchesState extends State<Matches> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    print(matches.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History',
            style: TextStyle(
                height: 1.5, fontWeight: FontWeight.bold, fontSize: 30)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.pink[200],
        elevation: 0,
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
          Center(
            child: GridView.count(
              childAspectRatio: 0.83,
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(matches.length, (index) {
                return InkWell(
                  child: Column(
                    children: [
                      Image.network(matchesImage[index]),
                      // Text(
                      //   '${matchesTitles[index]}',
                      //   style: Theme.of(context).textTheme.headline5,
                      // )
                    ],
                  ),
                  onTap: () {
                    current = index;
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => MatchInfo()));
                  },
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.pink[200],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_movies_outlined), label: 'Swipe'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: 'Matches'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Swiper(), maintainState: true));
          }
          if (_currentIndex == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(), maintainState: true));
          }
        },
      ),
    );
  }

  void _getPairData(pairName) async {
    var url =
        'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName?pairName=$pairName';
    final response = await Dio().get(url);
    var data = response.data['matches'];
    for (var i = 0; i < data.length; i++) {
      matches.add(data[i]);
    }
    print(matches);
    // print('response body ${response.data}');
    // _cloudData = data;
  }

  // void _postUser() async {
  //   Map<String, String> queryParams = {
  //     'userName': 'evilVic',
  //     'name': 'ric',
  //     'email': 'viccode@chihuahua.com',
  //   };
  //   var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
  //       "/createUser", queryParams);
  //   var response = await http.post(uri);
  //   print('response status: ${response.statusCode}');
  //   print('response body ${response.body}');
  //   var userData = response.body;
  // }
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
