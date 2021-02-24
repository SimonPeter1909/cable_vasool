import 'package:flutter/material.dart';

class AppNavigator {
  final BuildContext context;

  AppNavigator(this.context);

  Future push({@required Widget child}) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => child,
        ));
  }

  Future pushReplacement({@required Widget child}) async {
    return await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => child,
        ));
  }
}
