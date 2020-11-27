import 'package:flutter/material.dart';
//import 'components/body.dart';
//import 'components/signup_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterPractice/constants.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/signup";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up to Movie Night")),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              'Login Information',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email Address")),
            TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password")),
            RaisedButton(
                child: Text("SIGNUP"),
                onPressed: () async {
                  await auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text);
                }),

                
          ],
        ),
      ),
    );
  }
}
