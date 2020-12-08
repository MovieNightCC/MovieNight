import 'package:flutter/material.dart';
import '../sizeconfig.dart';
import './signinform.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/signin";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in Form"),
      ),
      body: SignInBody(),
    );
  }
}
