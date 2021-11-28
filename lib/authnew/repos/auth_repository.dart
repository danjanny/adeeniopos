import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  /// Check user session
  static Future<int?> checkUserSession() async {
    // if user session masih ada, then tampilkan customer RegisterPage()
    // if no user session, show WelcomePage()
    final prefs = await SharedPreferences.getInstance();
    var statusLoggedIn = prefs.getInt('admin_status_logged_in');
    return statusLoggedIn;
  }
}
