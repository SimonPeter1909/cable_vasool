import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Logout {
  logout(BuildContext context) async {
    await Preferences.clearPreference();
    Phoenix.rebirth(context);
  }
}
