import 'package:flutter/material.dart';
import 'components/body.dart';
import 'components/signup_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatelessWidget {
  static String routeName = "/signup";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up to Movie Night")),
      //body: Body(),
    );
  }
}
