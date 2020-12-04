import 'package:flutter/material.dart';
import '../sizeconfig.dart';
import 'onboardbody.dart';

class OnBoardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
