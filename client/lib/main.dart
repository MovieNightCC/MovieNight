import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';

import './screens/auth.dart';
import './screens/sign_in.dart';
import 'screens/swiper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

var userName = "";

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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

Future<Response> futureMovie;

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print(firebaseUser.email);
      userName =
          firebaseUser.email.substring(0, firebaseUser.email.indexOf("@"));
      // do future builder stuff he
      //  only fetch if movie length is zero]
      if (movieDataTest.length == 0 && movieImagesTest.length == 0) {
        futureMovie = fetchMovie();
      }
      // futureMovie = fetchMovie();
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
            print('${movieDataTest.length} how many movies I have');
            if (snapshot.hasData) {
              print("here in this if");
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

      //
    } else {
      return SignInPage();
    }
  }
}

Future<Response> fetchMovie() async {
  try {
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
      }
    }
  } catch (e) {
    // If the server did not return a 200 OK response,
    // then throw an exceptio
    print(e);
    throw Exception(
      'Failed to load album',
    );
  }
}
