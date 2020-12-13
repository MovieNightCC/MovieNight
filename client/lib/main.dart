//helper and config
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:dio/dio.dart';
// import './utils/colors.dart';

/// screens
import './utils/helpers.dart';
import './screens/movieArray.dart';
import './screens/movieInfo.dart';
import './screens/movieMatchesInfo.dart';
import './screens/onboard.dart';
import './screens/swiper.dart';
import './screens/auth.dart';
import './screens/rushMode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    App(),
  );
}

final ThemeData _kShrineTheme = _buildShrineTheme();
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      brightness: Brightness.light,
      primaryColor: Color(0xffe91e63),
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.pink,
      accentColor: Color(0xffe91e63),
      accentColorBrightness: Brightness.dark,
      canvasColor: Color(0xfffafafa),
      scaffoldBackgroundColor: Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.red,
      ),
      bottomAppBarColor: Colors.pink,
      cardColor: Colors.purple,
      dividerColor: Colors.grey,
      highlightColor: Color(0x66bcbcbc),
      splashColor: Color(0x66c8c8c8),
      selectedRowColor: Color(0xfff5f5f5),
      unselectedWidgetColor: Color(0x8a000000),
      disabledColor: Color(0x61000000),
      buttonColor: Colors.orange,
      toggleableActiveColor: Color(0xffd81b60),
      secondaryHeaderColor: Color(0xfffce4ec),
      backgroundColor: Color(0xfff48fb1),
      dialogBackgroundColor: Colors.grey[900],
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
var userIcon = "";
var partnerIcon = "";
var userPair = "";
var userEmail = "";
var displayName = "";
var howManyGay = 0;
var howManyAnime = 0;
var howManyHorror = 0;
var howManyJapan = 0;
var howManyKorea = 0;
var howManyRomance = 0;
var howManyMartialArts = 0;
var howManyMusic = 0;
var howManyScifi = 0;
var howManySuperHero = 0;
var notification;

// futureGay = fetchGay();
// futureAnime = fetchAnime();
// futureHorror = fetchHorror();
// futureJapan = fetchJapan();
// futureKorea = fetchKorea();

var matchOriLength = 0;
var cutInHalfCalled = false;
var pairFetchCounter = 0;
// List fetchArr = [];

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise(context) async {
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title:
                      new Text("Alert", style: TextStyle(color: Colors.black)),
                  content: new Text("$message",
                      style: TextStyle(color: Colors.black)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close me!'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    )
                  ],
                ));
        notification = PushNotificationMessage(
          title: message['notification']['title'],
          body: message['notification']['body'],
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}

class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}

class _AppState extends State<App> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // futureMovie = fetchMovie();
    // futureGay = fetchGay();
    // futureAnime = fetchAnime();
    // futureHorror = fetchHorror();
    // futureJapan = fetchJapan();
    // futureKorea = fetchKorea();
    // futureRomance = fetchRomance();
    // futureScifi = fetchScifi();
    // futureMartialArts = fetchMartialArts();
    // futureSuperHero = fetchSuperHero();
    // futureMusic = fetchMusic();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      print('this is from firebase messageing');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(userName)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Movie Night',
      'Channel to update Match Info and Rush Mode',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(message);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(firebaseMessaging);
    pushNotificationService.initialise(context);
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
//getting userInfo
  var url =
      'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getUserByUserName?userName=$userName';
  final response = await Dio().get(url);
  var userdata = response.data;
  userEmail = userdata["email"];
  userPair = userdata["pairName"];
  displayName = userdata["name"];
  print("pairName is $userPair");
  howManyGay = userdata["recommendations"]["LGBTQ"].round();
  howManyAnime = userdata["recommendations"]["Anime"].round();
  howManyHorror = userdata["recommendations"]["Horror"].round();
  howManyJapan = userdata["recommendations"]["Japanese"].round();
  howManyKorea = userdata["recommendations"]["Korean"].round();
  howManyRomance = userdata["recommendations"]["Romance"].round();
  howManyMartialArts = userdata["recommendations"]["MartialArts"].round();
  howManyMusic = userdata["recommendations"]["MusicInspired"].round();
  howManyScifi = userdata["recommendations"]["Scifi"].round();
  print('round called');
  howManySuperHero = userdata["recommendations"]["Superhero"].round();

  print('got user info ${userdata["email"]} in ${userdata["pairName"]}');
  userIcon = userdata["userIcon"];
  print('got user info ${userdata["userIcon"]} in ${userdata["pairName"]}');
}

Future<Response> fetchGay() async {
  try {
    if (gayNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getGayMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          gayList.add(movies[i]);
          gayNfid.add(movies[i]["nfid"]);
          gayGenre.add("LGBTQ");
          gaySynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          gayYear.add(movies[i]["year"]);
          gayRuntime.add(movies[i]["runtime"]);
          gayTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          gayImages.add(movies[i]["img"]);
        }
        return response;
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('_fetch gay error');
    }
  }
}

Future<Response> fetchAnime() async {
  try {
    if (animeNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAnimeMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          animeNfid.add(movies[i]["nfid"]);
          animeImages.add(movies[i]["img"]);
          animeGenre.add("Anime");
          animeTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          animeSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          animeYear.add(movies[i]["year"]);
          animeRuntime.add(movies[i]["runtime"]);
        }
        return response;
      } else {
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch anime error!');
    }
  }
}

Future<Response> fetchHorror() async {
  try {
    if (horrorNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getHorrorMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          horrorList.add(movies[i]);
          horrorNfid.add(movies[i]["nfid"]);
          horrorImages.add(movies[i]["img"]);
          horrorGenre.add("Horror");
          horrorTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          horrorSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          horrorYear.add(movies[i]["year"]);
          horrorRuntime.add(movies[i]["runtime"]);

          rushModeList.add(movies[i]);
          rushModeNfid.add(movies[i]["nfid"]);
          rushModeSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          rushModeYear.add(movies[i]["year"]);
          rushModeRuntime.add(movies[i]["runtime"]);
          rushModeGenre.add("Horror");
          rushModeTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          rushModeImages.add(movies[i]["img"]);
        }
        return response;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch horror error!');
    }
  }
}

Future<Response> fetchRomance() async {
  try {
    if (romanceNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getRomanceMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          romanceList.add(movies[i]);
          romanceNfid.add(movies[i]["nfid"]);
          romanceGenre.add("Romance");
          romanceImages.add(movies[i]["img"]);
          romanceTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          romanceSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          romanceYear.add(movies[i]["year"]);
          romanceRuntime.add(movies[i]["runtime"]);
        }
        return response;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch romance error!');
    }
  }
}

Future<Response> fetchMartialArts() async {
  try {
    if (martialArtsNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getMartialArtsMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          martialArtsNfid.add(movies[i]["nfid"]);
          martialArtsGenre.add("MartialArts");
          martialArtsImages.add(movies[i]["img"]);
          martialArtsTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          martialArtsSynopsis
              .add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          martialArtsYear.add(movies[i]["year"]);
          martialArtsRuntime.add(movies[i]["runtime"]);
        }
        return response;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch martialArts error!');
    }
  }
}

Future<Response> fetchSuperHero() async {
  try {
    if (superHeroNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getSuperHeroMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          superHeroNfid.add(movies[i]["nfid"]);
          superHeroGenre.add("Superhero");
          superHeroImages.add(movies[i]["img"]);
          superHeroTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          superHeroSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          superHeroYear.add(movies[i]["year"]);
          superHeroRuntime.add(movies[i]["runtime"]);
        }
        return response;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch super hero error!');
    }
  }
}

Future<Response> fetchScifi() async {
  try {
    if (scifiNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getScifiMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          scifiNfid.add(movies[i]["nfid"]);
          scifiGenre.add("Scifi");
          scifiImages.add(movies[i]["img"]);
          scifiTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          scifiSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          scifiYear.add(movies[i]["year"]);
          scifiRuntime.add(movies[i]["runtime"]);
        }
        return response;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch super hero error!');
    }
  }
}

Future<Response> fetchMusic() async {
  try {
    if (musicNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getMusicMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          musicNfid.add(movies[i]["nfid"]);
          musicGenre.add("MusicInspired");
          musicImages.add(movies[i]["img"]);
          musicTitles.add(movies[i]['title'].replaceAll('&#39;', "'"));
          musicSynopsis.add(movies[i]["synopsis"].replaceAll('&#39;', "'"));
          musicYear.add(movies[i]["year"]);
          musicRuntime.add(movies[i]["runtime"]);
        }
        return response;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  } catch (e) {
    if (e is DioError) {
      print('fetch super hero error!');
    }
  }
}

Future<Response> fetchJapan() async {
  try {
    if (japanNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getJapanMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          japanNfid.add(movies[i]["nfid"]);
          japanGenre.add("Japanese");
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
  } catch (e) {
    if (e is DioError) {
      print('fetch japanese error!');
    }
  }
}

Future<Response> fetchKorea() async {
  try {
    if (koreaNfid.length == 0) {
      final response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getKoreaMovies");
      if (response.statusCode == 200) {
        var movies = response.data;
        for (var i = 0; i < 80; i++) {
          koreaNfid.add(movies[i]["nfid"]);
          koreaGenre.add("Korean");
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
  } catch (e) {
    if (e is DioError) {
      print('fetch korea error!');
    }
  }
}

// Future<Response> futureMovie;
// Future<Response> futureGay;
// Future<Response> futureAnime;
// Future<Response> futureHorror;
// Future<Response> futureJapan;
// Future<Response> futureKorea;
// Future<Response> futureRomance;
// Future<Response> futureMusic;
// Future<Response> futureSuperHero;
// Future<Response> futureScifi;
// Future<Response> futureMartialArts;

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
        theme: _kShrineTheme,
        home: FutureBuilder(
          future: Future.wait([
            fetchGay(),
            fetchAnime(),
            fetchHorror(),
            fetchJapan(),
            fetchKorea(),
            fetchRomance(),
            fetchScifi(),
            fetchMartialArts(),
            fetchSuperHero(),
            fetchMusic(),
          ]),
          builder: (context, snapshot) {
            // print('${movieDataTest.length} how many movies I have');
            if (snapshot.hasData) {
              for (var i = 0; i < howManyAnime; i++) {
                movieDataTest.add(animeNfid[i]);
                moviesSynopsis.add(animeSynopsis[i]);
                movieYear.add(animeYear[i]);
                movieRuntime.add(animeRuntime[i]);
                movieTitles.add(animeTitles[i]);
                movieImagesTest.add(animeImages[i]);
                movieGenre.add("Anime");
              }
              for (var i = 0; i < howManyGay; i++) {
                movieDataTest.add(gayNfid[i]);
                moviesSynopsis.add(gaySynopsis[i]);
                movieYear.add(gayYear[i]);
                movieRuntime.add(gayRuntime[i]);
                movieTitles.add(gayTitles[i]);
                movieImagesTest.add(gayImages[i]);
                movieGenre.add("LGBTQ");
              }
              for (var i = 0; i < howManyHorror; i++) {
                movieDataTest.add(horrorNfid[i]);
                moviesSynopsis.add(horrorSynopsis[i]);
                movieYear.add(horrorYear[i]);
                movieRuntime.add(horrorRuntime[i]);
                movieTitles.add(horrorTitles[i]);
                movieImagesTest.add(horrorImages[i]);
                movieGenre.add("Horror");
              }
              for (var i = 0; i < howManyJapan; i++) {
                movieDataTest.add(japanNfid[i]);
                moviesSynopsis.add(japanSynopsis[i]);
                movieYear.add(japanYear[i]);
                movieRuntime.add(japanRuntime[i]);
                movieTitles.add(japanTitles[i]);
                movieImagesTest.add(japanImages[i]);
                movieGenre.add("Japanese");
              }

              for (var i = 0; i < howManyKorea; i++) {
                movieDataTest.add(koreaNfid[i]);
                moviesSynopsis.add(koreaSynopsis[i]);
                movieYear.add(koreaYear[i]);
                movieRuntime.add(koreaRuntime[i]);
                movieTitles.add(koreaTitles[i]);
                movieImagesTest.add(koreaImages[i]);
                movieGenre.add("Korean");
              }

              for (var i = 0; i < howManyRomance; i++) {
                movieDataTest.add(romanceNfid[i]);
                moviesSynopsis.add(romanceSynopsis[i]);
                movieYear.add(romanceYear[i]);
                movieRuntime.add(romanceRuntime[i]);
                movieTitles.add(romanceTitles[i]);
                movieImagesTest.add(romanceImages[i]);
                movieGenre.add("Romance");
              }
              for (var i = 0; i < howManyMartialArts; i++) {
                movieDataTest.add(martialArtsNfid[i]);
                moviesSynopsis.add(martialArtsSynopsis[i]);
                movieYear.add(martialArtsYear[i]);
                movieRuntime.add(martialArtsRuntime[i]);
                movieTitles.add(martialArtsTitles[i]);
                movieImagesTest.add(martialArtsImages[i]);
                movieGenre.add("MartialArts");
              }
              for (var i = 0; i < howManyMusic; i++) {
                movieDataTest.add(musicNfid[i]);
                moviesSynopsis.add(musicSynopsis[i]);
                movieYear.add(musicYear[i]);
                movieRuntime.add(musicRuntime[i]);
                movieTitles.add(musicTitles[i]);
                movieImagesTest.add(musicImages[i]);
                movieGenre.add("MusicInspired");
              }
              for (var i = 0; i < howManyScifi; i++) {
                movieDataTest.add(scifiNfid[i]);
                moviesSynopsis.add(scifiSynopsis[i]);
                movieYear.add(scifiYear[i]);
                movieRuntime.add(scifiRuntime[i]);
                movieTitles.add(scifiTitles[i]);
                movieImagesTest.add(scifiImages[i]);
                movieGenre.add("Scifi");
              }
              for (var i = 0; i < howManySuperHero; i++) {
                movieDataTest.add(superHeroNfid[i]);
                moviesSynopsis.add(superHeroSynopsis[i]);
                movieYear.add(superHeroYear[i]);
                movieRuntime.add(superHeroRuntime[i]);
                movieTitles.add(superHeroTitles[i]);
                movieImagesTest.add(superHeroImages[i]);
                movieGenre.add("Superhero");
              }
              print('movieRuntimeis $movieRuntime');
              shuffle(movieDataTest, movieImagesTest, movieTitles,
                  moviesSynopsis, movieYear, movieGenre, movieRuntime);
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
