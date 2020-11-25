import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:dio/dio.dart';

class Swiper extends StatefulWidget {
  static String routeName = "/swiper";
  _AppState createState() => _AppState();
}

class _AppState extends State<Swiper> {
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
  List<String> movies = [];

  List<String> movieImages = [
    "https://occ-0-2851-1432.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABYo08D3k24uEHYsBSuX5CguS0M2I0zrgWmDZxNH0vFlQfVpg_eVvg17agekWnzdboqg-oqoK8R1Aptc0HxkI9EnKSA.jpg?r=b9e",
    "https://occ-0-2851-1432.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABf0YHTcQ5ZbfdAYXGRs4xVxuhI5K0mmWGqkxtC1V6W712RsYMckydjZ5HT0F7sADOEuRuGWcgp9EJeHyNQRco1hJOQ.jpg?r=884",
    "https://occ-0-1007-1360.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABfbHqmRyebWamsZa28nK6QrHR5tS3cwd0Pb0nXFMi5MF9luHk0zqViLI8DmzX6SLdHDGvuqLW53uN3V2GG1PMC2xAw.jpg?r=947",
    // "https://occ-0-2717-360.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABbfqo7mBju7ZQXKtGagr_sgrd13DUqzf8-p6OZeoQbop0fToj4K9JImmM2DvNh2HmPt6_NW6Xnb4NLYUxuWH9ttAEGOPbX7mc0cPLpkX_Nrp18qZVyrr7ZpHVvc.jpg?r=f7e",
    // "assets/img/bored.jpg",
    // "assets/img/carumba.jpg",
    // "assets/img/chocolate.jpg",
    // "assets/img/wumbo.jpg",
    // "assets/img/dead.jpg",
    // "assets/img/dish.jpg",
    // "assets/img/fat.jpg",
    // "assets/img/firm.jpg",
    // "assets/img/god.jpg",
  ];

  void getHttp() async {
    try {
      Response response = await Dio().get(
          "https://asia-northeast1-movie-night-cc.cloudfunctions.net/getAllMovies");
      var pics = response.data;
      for (var i = 0; i < pics.length; i++) {
        movieImages.add(pics[i]["img"]);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getHttp();
    print(movieImages);
    return Scaffold(
      appBar: AppBar(
        title: Text("Swipe Movies"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: 100,
            stackNum: 3,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Card(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Image.network(
                    movieImages[index],
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
