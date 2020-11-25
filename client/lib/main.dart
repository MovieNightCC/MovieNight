import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void initState() {
      initializeFlutterFire();
      super.initState();
    }

    return MaterialApp(
      title: "Movie Night",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: Tinderswiper(),
    );
  }
}

class Tinderswiper extends StatefulWidget {
  @override
  _TinderswiperState createState() => _TinderswiperState();
}

class _TinderswiperState extends State<Tinderswiper>
    with TickerProviderStateMixin {
  List<String> movieImages = [
    "assets/img/bored.jpg",
    "assets/img/carumba.jpg",
    "assets/img/chocolate.jpg",
    "assets/img/wumbo.jpg",
    "assets/img/dead.jpg",
    "assets/img/dish.jpg",
    "assets/img/fat.jpg",
    "assets/img/firm.jpg",
    "assets/img/god.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swipe Movies"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: 9,
            stackNum: 3,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Card(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Image.asset(
                    '${movieImages[index]}',
                    fit: BoxFit.fill,
                  )),
              elevation: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
