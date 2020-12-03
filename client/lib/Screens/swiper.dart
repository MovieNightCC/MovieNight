import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import './tinderCard.dart';
import './matches.dart';
import './profile.dart';
import './movieInfo.dart';
import './rushMode.dart';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import './filterPopup.dart';
import '../main.dart';

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
  Future<Response> futureMovie;

  @override
  void initState() {
    super.initState();
    // futureMovie = fetchMovie();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Night",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.grey[900],
          scaffoldBackgroundColor: Colors.grey[900]),
      home: Tinderswiper(),
    );
  }
}

List shuffle(List listA, List listB, List listC, List listD, List listE) {
  var random = new Random();

  // Go through all elements.
  for (var i = listA.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = listA[i];
    var temp2 = listB[i];
    var temp3 = listC[i];
    var temp4 = listD[i];
    var temp5 = listE[i];
    // var temp6 = listF[i];
    // var temp7 = listG[i];
    // var temp8 = listH[i];
    // var temp9 = listI[i];
    // var temp10 = listJ[i];
    // var temp11 = listK[i];

    listA[i] = listA[n];
    listB[i] = listB[n];
    listC[i] = listC[n];
    listD[i] = listD[n];
    listE[i] = listE[n];
    // listF[i] = listF[n];
    // listG[i] = listG[n];
    // listH[i] = listH[n];
    // listI[i] = listI[n];
    // listJ[i] = listJ[n];
    // listK[i] = listK[n];

    listA[n] = temp;
    listB[n] = temp2;
    listC[n] = temp3;
    listD[n] = temp4;
    listE[n] = temp5;
    // listF[n] = temp6;
    // listG[n] = temp7;
    // listH[n] = temp8;
    // listI[n] = temp9;
    // listJ[n] = temp10;
    // listK[n] = temp11;
  }
  return listA;
}

List<Object> moviesList = [];
List<int> movieDataTest = [];
List<String> movieImagesTest = [];
List<String> movieTitles = [];
List<String> moviesSynopsis = [];
List<int> movieYear = [];
var counter = 0;

void updateUser(arrOfNfid, context, image, title, year, synopsis) async {
  print(userName);
  var response = await http.get(
      "https://asia-northeast1-movie-night-cc.cloudfunctions.net/updateUserLikes?userName=$userName&movieArr=[$arrOfNfid]");
  print(response.body);
  if (response.body == "match!") {
    //push to matches array

    matchesTitles.add(title);
    matchesSynopsis.add(synopsis);
    matchesImage.add(image);
    matchesYear.add(year);
    matchesNfid.add(arrOfNfid);

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Alert"),
              content: new Text("You got a Match!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
  }
}

class Tinderswiper extends StatefulWidget {
  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            children: [
              Center(
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: TinderSwapCard(
                      orientation: AmassOrientation.TOP,
                      totalNum: 100,
                      stackNum: 2,
                      swipeEdge: 5.0,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.width * 1.6,
                      minWidth: MediaQuery.of(context).size.width * 0.899,
                      minHeight: MediaQuery.of(context).size.width * 1.599,
                      cardBuilder: (context, index) {
                        return Card(
                          child: Container(
                              // padding: EdgeInsets.all(20.0),
                              child: Image.network(
                            movieImagesTest[index],
                            fit: BoxFit.fill,
                          )),
                          elevation: 0,
                        );
                      },
                      cardController: controller = CardController(),
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        if (orientation == CardSwipeOrientation.RIGHT) {
                          //when liked
                          print('you liked: ${movieDataTest[count]}');

                          //request to firebase server to update likes
                          updateUser(
                              movieDataTest[count],
                              context,
                              movieImagesTest[count],
                              movieTitles[count],
                              movieYear[count],
                              moviesSynopsis[count]);
                          count++;
                          // print(movieDataTest[index].runtimeType);

                          //  (?userName=<userName>&movieArr=<An Array of netflix IDs>)
                          // response = await dio.post("/test", data: {"id": 12, "name": "wendu"});

                        } else if (orientation == CardSwipeOrientation.LEFT) {
                          //when hated
                          print('you hate: ${movieDataTest[count]}');
                          count++;
                        }
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => Info()));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 80,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                print('pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RushMode(),
                      maintainState: true,
                    ));
              },
              tooltip: 'Increment',
              child: Icon(Icons.flash_on_sharp),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.red[400],
            ),
          ),
          Positioned(
            right: 80,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () => filterPop(context),
              tooltip: 'Increment',
              child: Icon(Icons.swap_calls, size: 40),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.blue[200],
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.purple[200],
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
            if (_currentIndex == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Matches(), maintainState: true));
            }
            if (_currentIndex == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                    maintainState: true,
                  ));
            }
          },
        ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.purple[200];
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
