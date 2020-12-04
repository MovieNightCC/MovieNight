//helper and config
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import './utitilities/colors.dart';
//mport 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// screens
import 'screens/swiper.dart';
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

final ThemeData _kShrineTheme = _buildShrineTheme();
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: Colors.pink[400],
      colorScheme: base.colorScheme.copyWith(
        secondary: Colors.white,
      ),
    ),
  );
}

// global user name variable accessible from every page
var userName = "";
var userPair = "";
var userEmail = "";
var displayName = "";
var matchOriLength = 0;
var cutInHalfCalled = false;

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // getUserInfo();
    futureMovie = fetchMovie();
    // futurePair = fetchPair();
    futureGay = fetchGay();
    futureAnime = fetchAnime();
    futureHorror = fetchHorror();
    futureJapan = fetchJapan();
    futureKorea = fetchKorea();
  }

//

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
        theme: _kShrineTheme,
        home: AuthenticationWrapper(),
        routes: routes,
      ),
    );
  }
}

void getUserInfo() async {
  print("getUserInfo is Called");

  try {
    var url =
        'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getUserByUserName?userName=$userName';
    final response = await Dio().get(url);
    var userdata = response.data;
    userEmail = userdata["email"];
    userPair = userdata["pairName"];
    displayName = userdata["name"];
    print('got user info ${userdata["email"]} in ${userdata["pairName"]}');

    if (matchesTitles.length == 0) {
      var url =
          'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName?pairName=$userPair';
      final response = await Dio().get(url);
      var data = response.data['matchMovieData'];
      if (response.statusCode == 200) {
        for (var i = 0; i < data.length; i++) {
          matches.add(data[i]);
          //    movieDataTest.add(movies[i]["nfid"]);
          matchesSynopsis.add(data[i]["synopsis"].replaceAll('&#39;', "'"));
          matchesYear.add(data[i]["year"]);
          matchesTitles.add(data[i]['title'].replaceAll('&#39;', "'"));
          matchesImage.add(data[i]["img"]);
          matchesNfid.add(data[i]["nfid"]);
          matchOriLength += 1;
        }
      }
    }
  } on Exception catch (_) {
    print('error!');
  }
}

Future<Response> fetchMovie() async {
  if (movieDataTest.length == 0) {
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
    if (response.statusCode == 200) {
      var movies = response.data;
      for (var i = 0; i < movies.length; i++) {
        // htmlParser.DocumentFragment.html("&#8211;").text
        // json.decode(utf8.decode(movies[i]["synopsis"]));
        moviesList.add(movies[i]);
        movieDataTest.add(movies[i]["nfid"]);
        // moviesSynopsis.add(json.decode(utf8.decode(movies[i]["synopsis"])
        moviesSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        movieYear.add(movies[i]["year"]);
        movieTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        movieImagesTest.add(movies[i]["img"]);
      }
      return response;
    } else {
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
        rushModeSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        rushModeYear.add(movies[i]["year"]);
        rushModeTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        rushModeImages.add(movies[i]["img"]);
        gayList.add(movies[i]);
        gayNfid.add(movies[i]["nfid"]);
        gaySynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        gayYear.add(movies[i]["year"]);
        gayTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        gayImages.add(movies[i]["img"]);
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
        animeTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        animeSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
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
        horrorTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        horrorSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
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
        japanTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        japanSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        japanYear.add(movies[i]["year"]);
      }
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
        koreaTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        koreaSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
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

Future<Response> futureMovie;
Future<Response> futureGay;
Future<Response> futureAnime;
Future<Response> futureHorror;
Future<Response> futureJapan;
Future<Response> futureKorea;

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      userName =
          firebaseUser.email.substring(0, firebaseUser.email.indexOf("@"));
      //put the function here
      getUserInfo();
      print('$userEmail');
      return MaterialApp(
        title: "Movie Night",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.grey[100]),
        home: FutureBuilder(
          future: Future.wait([
            futureMovie,
            futureGay,
            futureAnime,
            futureHorror,
            futureJapan,
            futureKorea
          ]),
          builder: (context, snapshot) {
            // print('${movieDataTest.length} how many movies I have');
            if (snapshot.hasData) {
              shuffle(
                movieDataTest,
                movieImagesTest,
                movieTitles,
                moviesSynopsis,
                movieYear,
              );
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
