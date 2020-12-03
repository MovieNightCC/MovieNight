import 'package:flutter/material.dart';
//import 'splashcontent.dart';
import 'package:flutterPractice/sizeconfig.dart';
import './sign_in.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Movie Night, Let’s start!",
      "image": "//s3.amazonaws.com/appforest_uf/f1600064155749x124567606870334980/NIVIA-01.jpg"
    },
    {
      "text": "Find a movie you both LOVE",
      "image": "client/assets/img/bored.jpg"
    },
    {
      "text": "In a few swipes you will be ready for movie night",
      "image": "client/assets/img/bored.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    
                    Spacer(flex: 3),
                    RaisedButton(
                      child: Text("Continue"),
                      onPressed: () {
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "MOVIE NIGHT",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            fontWeight: FontWeight.bold,
            color: Colors.pink
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.purple ),
        ),
        Spacer(flex: 2),
        Image.asset(
          image,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}