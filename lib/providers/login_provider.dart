import 'package:cable_vasool/api/models/login_model.dart';
import 'package:cable_vasool/api/repository.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get getLoading => _isLoading;

  set setLoading(bool value) {
    _isLoading = value;
  }

  login(BuildContext context, String email, String password) async {
    toggleLoading();

    LoginModel model = await Repository().doLogin(email, password);

    if (model == null) {
      toggleLoading();
      Fluttertoast.showToast(msg: 'Invalid Username / Password');
    } else {
      if (model.statusCode == 400) {
        toggleLoading();
        Fluttertoast.showToast(
            msg: '${model.message.first.messages.first.message}');
      } else {
        if (model.user.blocked) {
          toggleLoading();
          Fluttertoast.showToast(msg: 'Please Contact Admin');
        } else {
          if (model.jwt != null) {
            await Preferences.saveJWT('Bearer ${model.jwt}');
            await Preferences.setAdmin(model.user.userType == 'admin');
            await Preferences.setOperator(model.user.userType == 'owner');
            await Preferences.setCollector(model.user.userType == 'collector');

            await Preferences.saveOperatorId("${model.user.userOperator.id}");
            await Preferences.saveOperatorName(
                model.user.userOperator.operatorName);

            await Preferences.saveUserId("${model.user.id}");
            await Preferences.saveUserName(model.user.username);

            await Preferences.setLoginStatus(true);

            Fluttertoast.showToast(msg: 'Login Successful');

            Phoenix.rebirth(context);
          }
        }
      }
    }
  }

  void toggleLoading() {
    setLoading = !getLoading;
    notifyListeners();
  }
}
