import 'package:app/authpos/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  /// Check user session
  static Future<User?> checkUserSession() async {
    // if user session masih ada, then tampilkan customer RegisterPage()
    // if no user session, show WelcomePage()
    final prefs = await SharedPreferences.getInstance();
    var statusLoggedIn = prefs.getInt('admin_status_logged_in');

    // create logged-in user object
    var id = prefs.getString('id')!;
    var idGroupAccess = prefs.getString('id_group_access')!;
    var companyId = prefs.getString('company_id')!;
    var username = prefs.getString('username')!;
    var password = prefs.getString('password')!;
    var fullName = prefs.getString('full_name')!;
    var userObj =
        User(id, companyId, username, password, idGroupAccess, fullName);

    // return statusLoggedIn;
    return userObj;
  }
}
