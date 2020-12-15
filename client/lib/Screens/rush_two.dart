import 'dart:async';
import 'package:flutter/material.dart';
import './swiper.dart';
import './rushMode.dart';
import '../main.dart';
import 'package:neon/neon.dart';
import '../sizeconfig.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      PlayerLobby()
    ]));
  }
}

class TimerWidget extends StatefulWidget {
  State createState() => new _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer _timer;
  int _start = 3;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (mounted) {
          setState(() {
            if (_start < 1) {
              dispose();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RushMode(), maintainState: true));
              _start = 5;
            } else {
              _start = _start - 1;
            }
          });
        }
      });
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$_start",
            style: TextStyle(
                color: Colors.amberAccent,
                height: 1.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans',
                fontSize: 200)),
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
            width: 150.0,
            height: 150.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: new NetworkImage(imageIcon)))),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
            ),
          ),
        )
      ],
    );
  }
}

class PlayerLobby extends StatefulWidget {
  @override
  _PlayerLobbyState createState() => _PlayerLobbyState();
}

class _PlayerLobbyState extends State<PlayerLobby> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rushPlus')
            .doc(userPair)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //print("ICON ONE" + snapshot.data["iconOne"]);
          var playerOneJoined = snapshot.data["playerOneJoined"];
          var playerTwoJoined = snapshot.data["playerTwoJoined"];
          var playerOneIcon = snapshot.data["iconOne"];
          var playerTwoIcon = snapshot.data["iconTwo"];

          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else if (playerOneJoined && playerTwoJoined) {
            return Scaffold(
                body: Stack(children: [
              Positioned(
                  bottom: 20, child: Image.asset('./assets/img/fire.gif')),
              Center(
                  // heightFactor: 1.5,
                  child: Column(children: [
                TimerWidget(),
                Text("Both Player Joined!\nGet Ready...",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                    )),
              ]))
            ]));
          } else {
            return Stack(
              children: [
                Center(
                    child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 65),
                    child: Neon(
                      text: 'Rush Mode',
                      color: Colors.purple,
                      fontSize: 30,
                      font: NeonFont.Beon,
                      flickeringText: false,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Row(
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
                          ])),
                  Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Image.asset(
                          './assets/icons/loader-movie-night.gif',
                          scale: .6)),
                ])),
                Positioned(
                    right: 80,
                    bottom: 70,
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_back),
                      backgroundColor: Colors.pink,
                      onPressed: () {
                        endRush().then((value) {
                          print("end rush done!");
                          Navigator.pop(context);
                        });
                      },
                    ))
              ],
            );
          }
        });
  }
}
