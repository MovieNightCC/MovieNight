import 'dart:async';
import 'package:flutter/material.dart';
import './swiper.dart';
import './tinderCard.dart';
import './movieInfo.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import './filterPopup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './rushMode.dart';

//TODO get the timer s

// firebase functions file deploy only functions to update
// get the timer synced
// reset when game is done
// fetch movies

// create matches
//done
//https://www.netflix.com/title/80191740?preventIntent=true
//https://www.netflix.com/jp-en/title/70080038?preventIntent=true
// List<Object> rushModeList = [];
// List<int> rushModeNfid = [];
// List<String> rushModeImages = [];
// List<String> rushModeTitles = [];
// List<String> rushModeSynopsis = [];
// List<String> rushModeGenre = [];
// List<int> rushModeYear = [];
// List<int> rushModeRuntime = [];
String userPictureURL = "https://i.imgur.com/BoN9kdC.png";

class RushTwo extends StatefulWidget {
  @override
  _RushTwoState createState() => _RushTwoState();
}

class _RushTwoState extends State<RushTwo> {
  @override
  // CardController controller;
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        painter: HeaderCurvedContainer(),
      ),
      Column(children: [
        TimerWidget(),
      ])
    ]));
  }
}

class TimerWidget extends StatefulWidget {
  State createState() => new _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer _timer;
  int _start = 3;

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RushMode(), maintainState: true));
              _start = 3;
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_start",
            style: TextStyle(
                color: Colors.amberAccent,
                height: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 100)),
        // RaisedButton(
        //   onPressed: () {
        //     // send call to
        //     startTimer();
        //   },
        //   child: Text("start"),
        // ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rushPlus')
                .doc(userPair)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              var playerOneJoined = snapshot.data["playerOneJoined"];
              var playerTwoJoined = snapshot.data["playerTwoJoined"];
              var playerOneIcon = snapshot.data["iconOne"];
              var playerTwoIcon = snapshot.data["iconTwo"];

              if (!snapshot.hasData) {
                return LinearProgressIndicator();
              } else if (playerOneJoined && playerTwoJoined) {
                startTimer();
                return Text("both players joined");
              } else {
                return Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PicAndStatusColumn(
                          showText(playerOneJoined),
                          playerOneIcon,
                        ),
                        PicAndStatusColumn(
                          showText(playerTwoJoined),
                          playerTwoIcon,
                        ),
                      ]),
                ]);
              }
            }),
      ],
    );
  }
}

String showText(input) {
  if (input) {
    return "Joined";
  } else {
    return "Waiting....";
  }
}

// "https://i.imgur.com/BoN9kdC.png"
class PicAndStatusColumn extends StatelessWidget {
  final String label;
  final String imageIcon;
  const PicAndStatusColumn(this.label, this.imageIcon);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: new NetworkImage(imageIcon)))),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
