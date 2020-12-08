import 'dart:async';
import 'package:flutter/material.dart';
import './swiper.dart';
import './tinderCard.dart';
import './movieInfo.dart';
import 'dart:async';
import './filterPopup.dart';

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

class RushTwo extends StatefulWidget {
  @override
  _RushTwoState createState() => _RushTwoState();
}

class _RushTwoState extends State<RushTwo> {
  @override
  // CardController controller;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Text("name",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  height: 2.0,
                  fontWeight: FontWeight.bold)),
          Text("name2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  height: 2.0,
                  fontWeight: FontWeight.bold)),
          TimerWidget(),
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  State createState() => new _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer _timer;
  int _start = 10;

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
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                        title: new Text("Alert"),
                        content: new Text("Time's Up!"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Go Back to Swiper!'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Swiper(),
                                      maintainState: true));
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          )
                        ],
                      ));

              _start = 10;
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
        RaisedButton(
          onPressed: () {
            // send call to
            startTimer();
          },
          child: Text("start"),
        ),
      ],
    );
  }
}
