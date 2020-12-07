import 'package:flutter/material.dart';

import './swiper.dart';
import './profile.dart';
import './movieMatchesInfo.dart';
import './movieArray.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

var current = 0;

class _MatchesState extends State<Matches> {
  int _currentIndex = 2;
  // notify the snack bar when there is a change in match length

  @override
  Widget build(BuildContext context) {
    print(matchesGenre);
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
              children: List.generate(matchesTitles.length, (index) {
                return InkWell(
                  child: Column(
                    children: [
                      Image.network(matchesImage[index]),
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
