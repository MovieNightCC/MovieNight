import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPairPage extends StatelessWidget {
  final TextEditingController pairNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add pair page")),
      body: Column(
        children: [
          Text("Please enter you partner's username",
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  height: 2.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          TextField(
              controller: pairNameController,
              decoration: InputDecoration(labelText: "username"),
              style: TextStyle(
                  color: Colors.lightGreenAccent,
                  height: 2.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          RaisedButton(
            onPressed: () {
              // ignore: todo
              //TODO add the pair with cloud functions

              //Then route to profile page
            },
            child: Text("Add Partner"),
          )
        ],
      ),
    );
  }
}
