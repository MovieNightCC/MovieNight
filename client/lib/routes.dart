import 'package:flutter/widgets.dart';
import 'package:flutterPractice/Screens/signup/signup.dart';
import 'Screens/swiper.dart';
import 'Screens/signup/signup.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  Swiper.routeName: (context) => Swiper(),
  SignUp.routeName: (context) => SignUp()
};
