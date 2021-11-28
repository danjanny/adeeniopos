import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum Status { Uninitialized, Authenticating, Authenticated, Unauthenticated }

// store login info to SharedPreference
class LoginProvider with ChangeNotifier {
  String name = 'Login Provider Class';
  Status _status = Status.Uninitialized;

  LoginProvider() {
    // SharedPref check user login ?
    print("initialize class");
  }

  String getName() {
    return name;
  }
}
