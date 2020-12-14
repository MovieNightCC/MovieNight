import 'package:flutter/material.dart';
// import 'package:movie_night/screens/swiper.dart';
import 'signinscaffold.dart';
//import 'splashcontent.dart';
import '../sizeconfig.dart';
import './signinscaffold.dart';
import './signupscaffold.dart';
import 'package:neon/neon.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;

  List<Map<String, String>> splashData = [
    {
      "text": "Let's get started, swipe right to learn more.",
      "image": "assets/icons/icon-512x512-android.png",
    },
    {
      "text": "If you don't like as movie SWIPE the movie to the LEFT",
      "image": "assets/img/swipe-left.jpg"
    },
    {
      "text": "If you want to watch a movie, SWIPE the movie to the RIGHT",
      "image": "assets/img/swipe-right.jpg"
    },
    {
      "text": "Find your movie to watch tonight in a hurry with the Rush Mode ",
      "image": "assets/img/rush-mode.png"
    },
    {
      "text": "Let's get started with Movie Night Click on Sign Up",
      "image": "assets/img/opening.png"
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
                itemBuilder: (context, index) => SplashInfo(
                    splashData[index]["text"], splashData[index]["image"]),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Open Sans',
                            height: 1.0,
                            fontSize: 20),
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
                        onTap: () => Navigator.pushNamed(
                            context, SignInScreen.routeName),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Already a user ? Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontFamily: 'Open Sans',
                                fontSize: 15),
                          ),
                        )),
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
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
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

class SplashInfo extends StatelessWidget {
  final String label;
  final String imageIcon;
  const SplashInfo(this.label, this.imageIcon);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
            child: Neon(
              text: 'Movie Night',
              color: Colors.pink,
              fontSize: 32,
              font: NeonFont.Membra,
              flickeringText: false,
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'Open Sans',
            ),
          ),
        ),
        Image.asset(
          imageIcon,
          height: MediaQuery.of(context).size.height * 0.3,
        )
      ],
    );
  }
}
