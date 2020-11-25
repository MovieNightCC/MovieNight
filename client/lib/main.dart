import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:dio/dio.dart';
=======
import 'package:firebase_core/firebase_core.dart';
import 'Screens/swiper.dart';
import 'routes.dart';
>>>>>>> 40efe113fe1db931d0b1adcc7efcc6068d53e562

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Text("Something went wrong");
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Text("Loading");
    }

    return MaterialApp(
      title: "Movie Night",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[100]),
<<<<<<< HEAD
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
  void getHttp() async {
    try {
      Response response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllUsers");
      print(response);
    } catch (e) {
      print(e);
    }
  }

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
    getHttp();
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
=======
      home: Swiper(),
      routes: routes,
      
>>>>>>> 40efe113fe1db931d0b1adcc7efcc6068d53e562
    );
  }
}
