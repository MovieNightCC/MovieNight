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
              labelText: "Your partner's email",
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
            decoration:
                InputDecoration(labelText: "Enter a nickname for your pair"),
          ),
          Spacer(),
          RaisedButton(
            color: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            onPressed: () {
              // ignore: todo
              // check if user has a pair
              if (userPair == "") {
                //check if the user name exists
                print("called check for user");
                // ignore: unrelated_type_equality_checks
                _checkForUser().then((result) {
                  if (result == 69) {
                    showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              backgroundColor: Colors.grey[900],
                              title: new Text("Alert",
                                  style: TextStyle(color: Colors.grey[900])),
                              content: new Text(
                                  "Please enter a valid email address.",
                                  style: TextStyle(color: Colors.pinkAccent)),
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
                  }
                  if (!result) {
                    print("does not exist");
                    showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              title: new Text("Alert",
                                  style: TextStyle(color: Colors.grey[900])),
                              content: new Text("User does not exist!",
                                  style: TextStyle(color: Colors.white)),
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
                    userPair = coupleName;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(),
                            maintainState: true));
                  }
                });
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

  Future _checkForUser() async {
    userNameOfPair = pairNameController.text.trim();
    if (userNameOfPair.indexOf('@') == -1 || userNameOfPair == "") {
      return 69;
    }
    print(userNameOfPair);
    userNameOfPair = userNameOfPair.substring(0, userNameOfPair.indexOf("@"));
    print(userNameOfPair);
    var url =
        'https://asia-northeast1-movie-night-cc.cloudfunctions.net/checkValidUser?userName=$userNameOfPair';
    final response = await Dio().get(url);
    print('response ${response.data}');
    if (response.data == "false" || response.data == false) {
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

    print('response status: ${response.statusCode}');
    print('response body for creating a pair${response.body}');
  }
}
