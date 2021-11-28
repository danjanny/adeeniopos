import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Uninitialized,
  Authenticating,
  Authenticated,
  Unauthenticated,
  FirstInitialized
}

class AuthProvider with ChangeNotifier {
  String name = 'Auth Provider';
  Status _status = Status.Uninitialized;

  Status get status => _status;

  /// 3 kondisi
  /// 1. FirstInitialized : app launch for the first time
  /// 2. Unauthenticated : no user session logged-in
  /// 3. Authenticated : user session logged-in
  AuthProvider.instance() {
    SharedPreferences.getInstance().then((prefs) {
      var loginStatus = "";

      // cek user first time pake app nya ? tampilkan onboarding
      final firstInitStatus = prefs.getInt('first_initialized');
      if (firstInitStatus != 1) {
        _status = Status.FirstInitialized;
        loginStatus = "first_initialized";
        prefs.setInt('first_initialized', 1);
        notifyListeners();
      }

      // user sudah melihat onboarding
      if (loginStatus == "") {
        final loggedInStatus = prefs.getString('user_email');
        print("Logged In status : " + loggedInStatus.toString());
        if (loggedInStatus != null) {
          _status = Status.Authenticated;
        } else {
          _status = Status.Unauthenticated;
        }
        notifyListeners();
      }
    });
  }


  /// check user email
  Future<void> checkUserEmail() async {
    // check user email

  }

  Future<void> getName() async {
    print("ridha danjanny");
  }
}
