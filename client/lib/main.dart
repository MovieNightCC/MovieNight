//helper and config
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';

/// screens
import 'screens/swiper.dart';
import 'screens/matches.dart';
import 'screens/auth.dart';
import 'screens/sign_in.dart';
import 'screens/rushMode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

// global user name variable accessible from every page
var userName = "";
var userPair = "";
var userEmail = "";

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovie();
    futurePair = fetchPair();
    futureGay = fetchGay();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: "Movie Night",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.grey[100]),
        home: AuthenticationWrapper(),
        routes: routes,
      ),
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

Future<Response> fetchGay() async {
  if (movieDataTest.length == 0) {
    print("im called");
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getGayMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < 31; i++) {
        rushModeList.add(movies[i]);
        rushModeNfid.add(movies[i]["nfid"]);
        rushModeSynopsis.add(movies[i]["synopsis"]);
        rushModeYear.add(movies[i]["year"]);
        rushModeTitles.add(movies[i]['title']);
        rushModeImages.add(movies[i]["img"]);
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
  try {
    if (movieDataTest.length == 0) {
      print("im called");
      var url =
          'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName?pairName=testPairA';
      final response = await Dio().get(url);
      var data = response.data['matchMovieData'];
      if (response.statusCode == 200) {
        for (var i = 0; i < data.length; i++) {
          matches.add(data[i]);
          // movieDataTest.add(movies[i]["nfid"]);
          matchesSynopsis.add(data[i]["synopsis"]);
          matchesYear.add(data[i]["year"]);
          matchesTitles.add(data[i]['title']);
          matchesImage.add(data[i]["img"]);
          matchesNfid.add(data[i]["nfid"]);
        }
        print(matches);
        return response;
      }
    }
  } on Exception catch (_) {
    print('error!');
  }
}

Future<Response> futureMovie;
Future<Response> futurePair;
Future<Response> futureGay;
void getUserInfo() async {
  var url =
      'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getUserByUserName?userName=$userName';
  final response = await Dio().get(url);
  var userdata = response.data;
  userEmail = userdata["email"];
  userPair = userdata["pairName"];
  print('got user info $userdata');
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print(firebaseUser.email);
      userName =
          firebaseUser.email.substring(0, firebaseUser.email.indexOf("@"));
      //put the function here
      getUserInfo();
      return MaterialApp(
        title: "Movie Night",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.grey[100]),
        home: FutureBuilder(
          future: Future.wait([futureMovie, futurePair, futureGay]),
          builder: (context, snapshot) {
            print("future builder");
            print('${movieDataTest.length} how many movies I have');
            if (snapshot.hasData) {
              shuffle(movieDataTest, movieImagesTest, movieTitles,
                  moviesSynopsis, movieYear);
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
    } else {
      return SignInPage();
    }
  }
}
