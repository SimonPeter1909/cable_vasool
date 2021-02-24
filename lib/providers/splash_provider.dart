import 'package:cable_vasool/providers/admin/admin_dashboard_provider.dart';
import 'package:cable_vasool/providers/login_provider.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:cable_vasool/views/admin/admin_dashboard_screen.dart';
import 'package:cable_vasool/views/operator/operator_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/LoginScreen.dart';
import 'operator/operator_dashboard_provider.dart';

class SplashProvider with ChangeNotifier {
  checkUserExists(BuildContext context) async {
    if (await Preferences.isLoggedIn()) {

      if(await Preferences.isAdmin()){
        AppNavigator(context).pushReplacement(
            child: ChangeNotifierProvider<AdminDashboardProvider>(
              create: (BuildContext context) => AdminDashboardProvider(),
              builder: (context, child) => AdminDashboardScreen(),
            ));
      } else if(await Preferences.isOperator()){
        AppNavigator(context).pushReplacement(
            child: ChangeNotifierProvider<OperatorDashboardProvider>(
              create: (BuildContext context) => OperatorDashboardProvider(),
              builder: (context, child) => OperatorDashboard(),
            ));
      } else {

      }

    } else {
      AppNavigator(context).pushReplacement(
          child: ChangeNotifierProvider<LoginProvider>(
            create: (BuildContext context) => LoginProvider(),
            builder: (context, child) => LoginScreen(),
          ));
    }
  }
}
