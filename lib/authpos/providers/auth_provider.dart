import 'dart:convert';

import 'package:app/api_endpoint.dart';
import 'package:app/authpos/models/user_model.dart';
import 'package:app/simple_exception.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  /// user admin log in
  static Future<UserResponse?> userLogin(
      String username, String password) async {
    UserResponse userResponse;

    try {
      var params = {'username': username, 'password': password};
      var loginResponse = await http.post(Uri.parse(ApiEndpoint.authUrl),
          body: {"data": jsonEncode(params)});

      var loginResponseObj =
          UserResponse.fromJson(jsonDecode(loginResponse.body));

      if (loginResponseObj.status == 'error') {
        throw SimpleException(loginResponseObj.message);
      }

      // set admin_status_logged_in = 1, it means, user has logged in
      var userObj = loginResponseObj.user;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('admin_status_logged_in', 1);
      prefs.setString('id', userObj.id); // user id
      prefs.setString('username', userObj.username); // username

      userResponse = loginResponseObj;
    } catch (e) {
      userResponse = UserResponse.error('error', e.toString());
    }

    return userResponse;
  }

  /// User admin log out
  static Future<int> userLogout() async {
    final prefs = await SharedPreferences.getInstance();
    if (await prefs.remove('admin_status_logged_in') &&
        await prefs.remove('id') &&
        await prefs.remove('username')) {
      return 1;
    } else {
      return 0;
    }
  }
}
