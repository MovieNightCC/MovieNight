import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
