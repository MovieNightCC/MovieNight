import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './signup.dart';
import '../sizeconfig.dart';
import 'onboardbody.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
