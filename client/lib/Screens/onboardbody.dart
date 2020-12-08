import 'package:flutter/material.dart';
// import 'package:movie_night/screens/swiper.dart';
import 'signinscaffold.dart';
//import 'splashcontent.dart';
import '../sizeconfig.dart';
import './signinscaffold.dart';
import './signupscaffold.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Movie Night, Let’s start!",
      "image": "assets/img/App-logo.png"
    },
    {"text": "Find a movie you both LOVE", "image": "assets/img/bored.jpg"},
    {
      "text": "In a few swipes you will be ready for movie night",
      "image": "assets/img/Movienight1.png"
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
                    horizontal: getProportionateScreenWidth(100)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Spacer(),
                    FlatButton(
                      autofocus: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.pink,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, SignInScreen.routeName),
                      child: Text(
                        "Already a user ? Sign in",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
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
          "Movie Night",
          style: TextStyle(
              fontSize: getProportionateScreenWidth(36), color: Colors.pink),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.purple),
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
