import 'package:flutter/widgets.dart';
import './screens/signinscaffold.dart';
import './screens/onboardsplash.dart';
import './screens/swiper.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  Swiper.routeName: (context) => Swiper(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
};
