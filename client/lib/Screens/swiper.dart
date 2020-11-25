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
    "https://occ-0-2851-38.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABbfzWC5RVgFT8kQt7PgHVZC8NxDbqPHwOc-ItTMpw9As4MPReNZF6WXi9OON2_2eekS6xshj8wsCEzVcvattQT5vsEuI9t-T_wExyo6FsA90ibRTkP8MQ3Oy9QA.jpg?r=848",
    "https://occ-0-2851-38.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABebXub2bi247otQst_hOZO3nGA_tmisdBih1FgmhhDXizhqyNhSJKmcCkW9EjZSuLw9-4b-yvc89Lf2zK2Zh4Ab4d3dciKVOOTfjYUFoNy96k7C63bzHlETPUaM.jpg?r=08c",
    "https://occ-0-2851-38.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABZsccQeCfH1sB-4d1WnIKXXEbqLHYALSo1QCOrGrd5vuwXjLSSiNuIfxYmscIU7vRavU6929JPe1NILHC5vZYnKfUMsnhr4IFmnUefvFCgNO3i-vkid-lwt5GXU.jpg?r=4fa",
    "https://occ-0-2717-360.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABbfqo7mBju7ZQXKtGagr_sgrd13DUqzf8-p6OZeoQbop0fToj4K9JImmM2DvNh2HmPt6_NW6Xnb4NLYUxuWH9ttAEGOPbX7mc0cPLpkX_Nrp18qZVyrr7ZpHVvc.jpg?r=f7e",
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
            totalNum: 20,
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
