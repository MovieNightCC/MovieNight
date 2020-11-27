import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/swiper.dart';
import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';

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

  Future<Response> futureMovie;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    futureMovie = fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    // if (_error) {
    //   return Text("Something went wrong");
    // }

    // // Show a loader until FlutterFire is initialized
    // if (!_initialized) {
    //   return Text("Loading");
    // }

    return MaterialApp(
      title: "Movie Night",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: FutureBuilder(
        future: futureMovie,
        builder: (context, snapshot) {
          print("future builder");
          // print(snapshot.data);
          // print(movieDataTest);
          print(movieDataTest.length);
          if (snapshot.hasData) {
            shuffle(movieDataTest, movieImagesTest);
            return Swiper();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
      routes: routes,
    );
  }
}

Future<Response> fetchMovie() async {
  if (movieDataTest.length == 0) {
    print("im called");
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        movieDataTest.add(movies[i]["nfid"]);
        movieImagesTest.add(movies[i]["img"]);
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

//     return MaterialApp(
//       title: "Movie Night",
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primaryColor: Colors.white,
//           scaffoldBackgroundColor: Colors.grey[100]),
//       home: Swiper(),
//       routes: routes,
//     );
//   }
// }
