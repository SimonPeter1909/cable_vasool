import 'package:after_layout/after_layout.dart';
import 'package:cable_vasool/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlueAccent, Colors.white])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 70.0, bottom: 20.0),
              child: new Text(
                "Cable Admin",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(10.0),
              child: new Icon(
                Icons.bubble_chart,
                color: Colors.white,
                size: 130.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<SplashProvider>(context,listen: false).checkUserExists(context);
  }
}
