import 'package:flutter/material.dart';
//import 'package:cloud_functions/cloud_functions.dart';
//mport 'package:cloud_firestore/cloud_firestore.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class Matches extends StatelessWidget {
  // FirebaseFunctions functions = FirebaseFunctions.instance;
  var _cloudData = "The pope";
  // Future<void> getFruit() async {
  //   HttpsCallable callable =
  //       FirebaseFunctions.instance.httpsCallable('helloWorld');
  //   final results = await callable();
  //   var fruit =
  //       results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("hello");
          _getcloudData();
          _postUser();
          Navigator.pop(context);
        },
      ),
      body: Container(
        child: Center(
          child: Text(
            _cloudData,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _getcloudData() async {
    var url =
        "https://asia-northeast1-movie-night-cc.cloudfunctions.net/helloWorld";
    var response = await http.get(url);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    _cloudData = response.body;
  }

  void _postUser() async {
    Map<String, String> queryParams = {
      'userName': 'evilVic',
      'name': 'ric',
      'email': 'viccode@chihuahua.com',
    };
    var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
        "/createUser", queryParams);

// // http://example.org/path?q=dart.
// Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net", "/createUser", queryParams);

    var response = await http.post(uri);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    var userData = response.body;
  }
}
