import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/swiper.dart';
import 'Screens/matches.dart';
import 'Screens/profile.dart';

import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

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
  Future<Response> futurePair;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    futureMovie = fetchMovie();
    futurePair = fetchPair();
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
        future: Future.wait([futureMovie, futurePair]),
        // future: futureMovie,
        builder: (context, snapshot) {
          // print(snapshot.data);
          // print(movieDataTest);

          if (snapshot.hasData) {
            shuffle(movieDataTest, movieImagesTest, movieTitles, moviesSynopsis,
                movieYear);
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
        moviesList.add(movies[i]);
        movieDataTest.add(movies[i]["nfid"]);
        moviesSynopsis.add(movies[i]["synopsis"]);
        movieYear.add(movies[i]["year"]);
        movieTitles.add(movies[i]['title']);
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

Future<Response> fetchPair() async {
  if (movieDataTest.length == 0) {
    print("im called");
    var url =
        'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName?pairName=testPairA';
    final response = await Dio().get(url);
    var data = response.data['matches'];
    if (response.statusCode == 200) {
      for (var i = 0; i < data.length; i++) {
        matches.add(data[i]);
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
