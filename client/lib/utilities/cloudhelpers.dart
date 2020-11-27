import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



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
      'userName': 'niceVic',
      'name': 'tic',
      'email': 'ticcode@chihuahua.com',
    };
    var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
        "/createUser", queryParams);

    var response = await http.post(uri);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    var userData = response.body;
  }

  void _postPair() async {
    Map<String, String> queryParams = {
      'pairName': 'niceVic',
      'user1': 'evilVic',
      'user2': 'niceVic',
    };
    var uri = Uri.https("asia-northeast1-movie-night-cc.cloudfunctions.net",
        "/createPair", queryParams);

// createPair (https://asia-northeast1-movie-night-cc.cloudfunctions.net/createPair)
// query params: userName,email,name
// (?pairName=<pairName>&user1=<user1>&user2=<user2>)
// initalizing a user with empty likes,dislikes and pair belonged

    var response = await http.post(uri);
    print('response status: ${response.statusCode}');
    print('response body ${response.body}');
    var pairData = response.body;
  }
}