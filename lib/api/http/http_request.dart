import 'package:cable_vasool/utils/SharedPreferences.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Request {
  Future<String> post(
      {@required String url, @required Map<String, String> body}) async {
    try {
      var res = await http.post(url,
          body: body,
          headers: {"Authorization": await Preferences.getJWT() ?? ""});
      logger.d(res.body);
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return null;
      }
    } catch (e) {
      logger.e('response error - $e');
      return null;
    }
  }
}
