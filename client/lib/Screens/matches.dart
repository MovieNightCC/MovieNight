import 'package:flutter/material.dart';
import './swiper.dart';
import './profile.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  int _currentIndex = 2;
  var _cloudData = "The pope";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("hello");
          _getcloudData();
          _postUser();
          Navigator.pop(context);
        },
      ),
      body: Container(
        child: Center(
          child: Text(
            _cloudData,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
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

  void _getcloudData() async {
    var url =
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/helloWorld";
    var response = await http.get(url);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    _cloudData = response.body;
  }

  void _postUser() async {
    Map<String, String> queryParams = {
      'userName': 'niceVic',
      'name': 'tic',
      'email': 'ticcode@chihuahua.com',
    };
    var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
        "/createUser", queryParams);

    var response = await http.post(uri);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    var userData = response.body;
  }

  void _postPair() async {
    Map<String, String> queryParams = {
      'pairName': 'niceVic',
      'user1': 'evilVic',
      'user2': 'niceVic',
    };
    var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
        "/createPair", queryParams);

// createPair (https://asia-northeast1-movie-night-cc.cloudfunctions.net/createPair)
// query params: userName,email,name
// (?pairName=<pairName>&user1=<user1>&user2=<user2>)
// initalizing a user with empty likes,dislikes and pair belonged

    var response = await http.post(uri);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    var pairData = response.body;
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue[200];
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
