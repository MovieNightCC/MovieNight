import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import './profile.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import 'profile.dart';

bool userexists = false;
String userNameOfPair = "";
String coupleName = "";

class AddPairPage extends StatelessWidget {
  final TextEditingController pairNameController = TextEditingController();
  final TextEditingController coupleNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add pair page")),
      body: Column(
        children: [
          Text(
            "Please enter you partner's username",
          ),
          TextField(
            controller: pairNameController,
            decoration: InputDecoration(
              labelText: "username",
            ),
          ),
          Text("Please enter the name for your couple",
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  height: 2.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          TextField(
            controller: coupleNameController,
            decoration: InputDecoration(labelText: "couple name"),
          ),
          RaisedButton(
            onPressed: () {
              // ignore: todo
              // check if user has a pair
              if (userPair == "") {
                //check if the user name exists
                _checkForUser();
                print("called check for user");
                if (userexists == false) {
                  print("does not exist");
                } else {
                  print("user exists form the pair");
                  _postNewPair();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(),
                          maintainState: true));
                }
              }
            },
            child: Text("Add Partner"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(), maintainState: true));
            },
            child: Text("Skip do not add a partner for now"),
          )
        ],
      ),
    );
  }

  void _checkForUser() async {
    userNameOfPair = pairNameController.text.trim();
    var url =
        'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getUserByUserName?userName=$userNameOfPair';
    final response = await Dio().get(url);
    print('response $response');
    if (response.data == false) {
      userexists = false;
    } else {
      userexists = true;
    }
  }

  void _postNewPair() async {
    coupleName = coupleNameController.text.trim();

    Map<String, String> queryParams = {
      'pairName': coupleName,
      'user1': userName,
      'user2': userNameOfPair,
    };
    print(queryParams);
    var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
        "/createPair", queryParams);

    var response = await http.post(uri);
    print('response status: ${response.statusCode}');
    print('response body for creating a pair${response.body}');
  }
}
