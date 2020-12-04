//helper and config
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Screens/onboard.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

/// screens
import 'screens/swiper.dart';
import 'screens/auth.dart';
//import 'screens/sign_in.dart';
import 'screens/rushMode.dart';
import 'screens/movieArray.dart';
import './screens/movieInfo.dart';
import './screens/movieMatchesInfo.dart';

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
      brightness: Brightness.light,
      primaryColor: Color(0xffe91e63),
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Color(0xfff8bbd0),
      primaryColorDark: Color(0xffc2185b),
      accentColor: Color(0xffe91e63),
      accentColorBrightness: Brightness.dark,
      canvasColor: Color(0xfffafafa),
      scaffoldBackgroundColor: Colors.black,
      bottomAppBarColor: Color(0xffffffff),
      cardColor: Color(0xffffffff),
      dividerColor: Color(0x1f000000),
      highlightColor: Color(0x66bcbcbc),
      splashColor: Color(0x66c8c8c8),
      selectedRowColor: Color(0xfff5f5f5),
      unselectedWidgetColor: Color(0x8a000000),
      disabledColor: Color(0x61000000),
      buttonColor: Colors.orange,
      toggleableActiveColor: Color(0xffd81b60),
      secondaryHeaderColor: Color(0xfffce4ec),
      textSelectionColor: Color(0xfff48fb1),
      cursorColor: Color(0xff4285f4),
      textSelectionHandleColor: Color(0xfff06292),
      backgroundColor: Color(0xfff48fb1),
      dialogBackgroundColor: Color(0xffffffff),
      indicatorColor: Color(0xffe91e63),
      hintColor: Colors.pinkAccent,
      errorColor: Colors.purple[900],
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          minWidth: 88,
          height: 36,
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.pink,
              width: 1,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          )));
}

// global user name variable accessible from every page
var userName = "";
var userPair = "";
var userEmail = "";
var displayName = "";
var matchOriLength = 0;
var cutInHalfCalled = false;
var pairFetchCounter = 0;
List fetchArr = [];

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovie();
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
    print('got user info ${userdata["email"]} in ${userdata["pairName"]}');

    if (matchesTitles.length == 0) {
      var url =
          'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairMatches?pairName=$userPair';
      final response = await Dio().get(url);
      var data = response.data;
      if (response.statusCode == 200) {
        for (var i = 0; i < data.length; i++) {
          matches.add(data[i]);
          //    movieDataTest.add(movies[i]["nfid"]);
          matchesSynopsis.add(data[i]["synopsis"].replaceAll('&#39;', "'"));
          matchesYear.add(data[i]["year"]);
          matchesRuntime.add(data[i]["runtime"]);
          matchesTitles.add(data[i]['title'].replaceAll('&#39;', "'"));
          matchesImage.add(data[i]["img"]);
          matchesGenre.add(data[i]["genre"]);
          print(matchesGenre[matchesGenre.length - 1]);
          matchesNfid.add(data[i]["nfid"]);
          matchOriLength += 1;
        }
      }
      fetchArr.add(matchOriLength);
    }
  } on Exception catch (_) {
    print('error!');
  }
}

Future<Response> fetchMovie() async {
  if (movieDataTest.length == 0) {
    final response = await Dio().get(
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllNewMovies");
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
        movieRuntime.add(movies[i]["runtime"]);
        movieTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        movieImagesTest.add(movies[i]["img"]);
        movieGenre.add(movies[i]["genre"]);
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
        rushModeRuntime.add(movies[i]["runtime"]);
        rushModeGenre.add(movies[i]["genre"]);
        rushModeTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        rushModeImages.add(movies[i]["img"]);
        gayList.add(movies[i]);
        gayNfid.add(movies[i]["nfid"]);
        gayGenre.add(movies[i]["genre"]);
        gaySynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        gayYear.add(movies[i]["year"]);
        gayRuntime.add(movies[i]["runtime"]);
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
        animeGenre.add(movies[i]["genre"]);
        animeTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        animeSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        animeYear.add(movies[i]["year"]);
        animeRuntime.add(movies[i]["runtime"]);
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
        horrorGenre.add(movies[i]["genre"]);
        horrorTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        horrorSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        horrorYear.add(movies[i]["year"]);
        horrorRuntime.add(movies[i]["runtime"]);
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
        japanGenre.add(movies[i]["genre"]);
        japanImages.add(movies[i]["img"]);
        japanTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        japanSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        japanYear.add(movies[i]["year"]);
        japanRuntime.add(movies[i]["runtime"]);
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
        koreaGenre.add(movies[i]["genre"]);
        koreaImages.add(movies[i]["img"]);
        koreaTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
        koreaSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
        koreaYear.add(movies[i]["year"]);
        koreaRuntime.add(movies[i]["runtime"]);
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

// Future<Response> fetchMatches() async {
//   print("fetchMatches is Called");
//   try {
//     if (movieDataTest.length == 0) {
//       var url =
//           'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getPairByPairName?pairName=testPairA';
//       final response = await Dio().get(url);
//       var data = response.data['matchMovieData'];
//       if (response.statusCode == 200) {
//         for (var i = 0; i < data.length; i++) {
//           matches.add(data[i]);
//           //    movieDataTest.add(movies[i]["nfid"]);
//           matchesSynopsis.add(data[i]["synopsis"].replaceAll('&#39;', "'"));
//           matchesYear.add(data[i]["year"]);
//           matchesTitles.add(data[i]['title'].replaceAll('&#39;', "'"));
//           matchesImage.add(data[i]["img"]);
//           matchesNfid.add(data[i]["nfid"]);
//         }
//         return response;
//       }
//     }
//   } on Exception catch (_) {
//     print('error!');
//   }
// }

Future<Response> futureMovie;
// Future<Response> futurePair;
Future<Response> futureGay;
Future<Response> futureAnime;
Future<Response> futureHorror;
Future<Response> futureJapan;
Future<Response> futureKorea;

class AuthenticationWrapper extends StatelessWidget {
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
        theme: _kShrineTheme,
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
              shuffle(movieDataTest, movieImagesTest, movieTitles,
                  moviesSynopsis, movieYear, movieGenre, movieRuntime);
              changeToHours();
              changeToHoursMatches();
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
      return OnBoardScreen();
    }
  }
}
