import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/main.dart';
import './movieArray.dart';
import './movieMatchesInfo.dart';
import './swiper.dart';
import './profile.dart';
import 'addPairPage.dart';
import 'package:neon/neon.dart';

class DummyMatches extends StatefulWidget {
  @override
  _DummyMatchesState createState() => _DummyMatchesState();
}

var current = 0;

class _DummyMatchesState extends State<DummyMatches> {
  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Neon(
          text: 'Matches',
          color: Colors.purple,
          fontSize: 24,
          font: NeonFont.Membra,
          flickeringText: false,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.pink,
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
              child: Container(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(100),
                        ),
                        Text(
                            "You have no partner. Add a Partner to get matches!",
                            style: TextStyle(fontSize: 20)),
                        Padding(
                          padding: EdgeInsets.all(20),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: Text(
                            "Link with your partner",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.pink,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPairPage()));
                          },
                        ),
                      ]))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.pink,
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
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.pink;
    Path path = Path()
      ..relativeLineTo(0, 70)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 70)
      ..relativeLineTo(0, -100)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
