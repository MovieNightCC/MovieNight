//helper and config
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

/// screens
import 'screens/swiper.dart';
import 'screens/matches.dart';
import 'screens/auth.dart';
import 'screens/sign_in.dart';
import 'screens/rushMode.dart';
import 'screens/movieArray.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    Phoenix(
      child: App(),
    ),
  );
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
    futureAnime = fetchAnime();
    futureHorror = fetchHorror();
    futureJapan = fetchJapan();
    futureKorea = fetchKorea();
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
  if (rushModeList.length == 0) {
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

//anime,horror,japan,korea

Future<Response> fetchAnime() async {
  if (animeList.length == 0) {
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAnimeMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        animeList.add(movies[i]);
        animeNfid.add(movies[i]["nfid"]);
        animeImages.add(movies[i]["img"]);
        animeTitles.add(movies[i]['title']);
        animeSynopsis.add(movies[i]["synopsis"]);
        animeYear.add(movies[i]["year"]);
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

Future<Response> fetchHorror() async {
  if (horrorList.length == 0) {
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getHorrorMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        horrorList.add(movies[i]);
        horrorNfid.add(movies[i]["nfid"]);
        horrorImages.add(movies[i]["img"]);
        horrorTitles.add(movies[i]['title']);
        horrorSynopsis.add(movies[i]["synopsis"]);
        horrorYear.add(movies[i]["year"]);
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

Future<Response> fetchJapan() async {
  if (japanList.length == 0) {
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getJapanMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        japanList.add(movies[i]);
        japanNfid.add(movies[i]["nfid"]);
        japanImages.add(movies[i]["img"]);
        japanTitles.add(movies[i]['title']);
        japanSynopsis.add(movies[i]["synopsis"]);
        japanYear.add(movies[i]["year"]);
      }
      print("japanList length from main.dart ${japanList.length}");
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

Future<Response> fetchKorea() async {
  if (koreaList.length == 0) {
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getKoreaMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        koreaList.add(movies[i]);
        koreaNfid.add(movies[i]["nfid"]);
        koreaImages.add(movies[i]["img"]);
        koreaTitles.add(movies[i]['title']);
        koreaSynopsis.add(movies[i]["synopsis"]);
        koreaYear.add(movies[i]["year"]);
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
      var url =
          'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName?pairName=testPairA';
      final response = await Dio().get(url);
      var data = response.data['matchMovieData'];
      if (response.statusCode == 200) {
        for (var i = 0; i < data.length; i++) {
          matches.add(data[i]);
          //    movieDataTest.add(movies[i]["nfid"]);
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
Future<Response> futureAnime;
Future<Response> futureHorror;
Future<Response> futureJapan;
Future<Response> futureKorea;

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
          // futureAnime = fetchAnime();
          // futureHorror = fetchHorror();
          // futureJapan = fetchJapan();
          // futureKorea = fetchKorea();
          future: Future.wait([
            futureMovie,
            futurePair,
            futureGay,
            futureAnime,
            futureHorror,
            futureJapan,
            futureKorea
          ]),
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
