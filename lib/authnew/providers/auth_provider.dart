import 'dart:convert';
import 'dart:io';

import 'package:app/authnew/models/user_model.dart';
import 'package:app/constant.dart';
import 'package:app/simple_exception.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum StatusUser {
  userHasNotRegistered,
  userHasRegistered,
  authServerError,
  authClientError
}

class AuthProvider with ChangeNotifier {
  StatusUser _statusUser = StatusUser.userHasNotRegistered;

  StatusUser get statusUser => _statusUser;

  Future<UserResponse?> checkEmail(String? email) async {
    UserResponse userResponse;
    try {
      var params = {'email': email};

      var checkUserEmailResponse = await http.post(
          Uri.parse(Constant.checkUserEmail),
          body: {"data": jsonEncode(params)});

      var userResponseObj =
          UserResponse.fromJson(jsonDecode(checkUserEmailResponse.body));

      if (userResponseObj.status == 'error') {
        _statusUser = StatusUser.authServerError;
        notifyListeners();
        throw SimpleException(userResponseObj.message);
      }

      if (userResponseObj.statusUser == 'registered') {
        _statusUser = StatusUser.userHasRegistered;
        notifyListeners();
      } else {
        _statusUser = StatusUser.userHasNotRegistered;
        notifyListeners();
      }

      userResponse = userResponseObj;
    } on SocketException catch (e) {
      // device no connection
      userResponse =
          UserResponse.error(status: 'error', message: "Cek koneksi HP anda");
    } catch (e) {
      // server error
      userResponse = UserResponse.error(status: 'error', message: e.toString());
    }
    return userResponse;
  }
}
