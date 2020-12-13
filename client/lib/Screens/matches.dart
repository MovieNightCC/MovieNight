import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_night/main.dart';
import './movieArray.dart';
import './movieMatchesInfo.dart';
import './swiper.dart';
import './profile.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

var current = 0;
List matchesMovieData = [];

class _MatchesState extends State<Matches> {
  int _currentIndex = 2;
  // notify the snack bar when there is a change in match length
  List matchesArray = [];
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('pairs')
          .doc(userPair)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        matchesMovieData = snapshot.data['matchMovieData'].reversed.toList();
        if (matchesMovieData.length != 0) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Match History',
                  style: TextStyle(
                      height: 1.5, fontWeight: FontWeight.bold, fontSize: 30)),
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
                  child: GridView.count(
                    childAspectRatio: 0.70,
                    crossAxisCount: 2,
                    children: List.generate(matchesMovieData.length, (index) {
                      return InkWell(
                        child: Column(
                          children: [
                            Image.network(matchesMovieData[index]["img"]),
                          ],
                        ),
                        onTap: () {
                          current = index;
                          print("current $current");
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
              backgroundColor: Colors.pink,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
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
                          builder: (context) => Profile(),
                          maintainState: true));
                }
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Match History',
                  style: TextStyle(
                      height: 1.5, fontWeight: FontWeight.bold, fontSize: 30)),
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
                  child: GridView.count(
                    childAspectRatio: 0.70,
                    crossAxisCount: 2,
                    children: List.generate(matchesMovieData.length, (index) {
                      return InkWell(
                        child: Column(
                          children: [
                            Image.network(matchesMovieData[index]["img"]),
                          ],
                        ),
                        onTap: () {
                          current = index;
                          print("current $current");
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
              backgroundColor: Colors.pink,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
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
                          builder: (context) => Profile(),
                          maintainState: true));
                }
              },
            ),
          );
        }
      },
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
