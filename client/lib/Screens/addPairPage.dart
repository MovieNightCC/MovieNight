import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import './profile.dart';

String userNameOfPair = "";
String coupleName = "";

class AddPairPage extends StatelessWidget {
  final TextEditingController pairNameController = TextEditingController();
  final TextEditingController coupleNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Link with your partner"), backgroundColor: Colors.pink),
      body: Column(
        children: [
          TextField(
            controller: pairNameController,
            decoration: InputDecoration(
              labelText: "Your partner's name",
            ),
          ),
          Text("Link your partner's account here",
              style: TextStyle(
                  color: Colors.pink,
                  height: 2.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          TextField(
            controller: coupleNameController,
            decoration: InputDecoration(labelText: "Define your Team's name"),
          ),
          Spacer(),
          RaisedButton(
            color: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            onPressed: () async {
              // ignore: todo
              // check if user has a pair
              if (userPair == "") {
                //check if the user name exists

                print("called check for user");
                // ignore: unrelated_type_equality_checks
                if (_checkForUser() == false) {
                  print("does not exist");
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            title: new Text("Alert",
                                style: TextStyle(color: Colors.black)),
                            content: new Text("User does not exist!",
                                style: TextStyle(color: Colors.black)),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Close me!'),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              )
                            ],
                          ));
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
          Spacer(),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(), maintainState: true));
            },
            child: Text("I will link my partner later",
                style: TextStyle(color: Colors.white)),
          ),
          Spacer()
        ],
      ),
    );
  }

  Future<bool> _checkForUser() async {
    userNameOfPair = pairNameController.text.trim();
    var url =
        'https://asia-northeast1-movie-night-cc.cloudfunctions.net/getUserByUserName?userName=$userNameOfPair';
    final response = await Dio().get(url);
    print('response $response');
    if (response.data == false) {
      return false;
    } else {
      return true;
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
    userPair = coupleName;
    print('response status: ${response.statusCode}');
    print('response body for creating a pair${response.body}');
  }
}
