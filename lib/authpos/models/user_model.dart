import 'package:app/simple_exception.dart';

class UserResponse {
  late String status;
  late String message;
  late User user;

  UserResponse(this.status, this.message, this.user);

  UserResponse.error(this.status, this.message);

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    UserResponse userResponse;
    try {
      if (json['status'] == 'error') {
        throw SimpleException(json['message']);
      }

      var user = User.fromJson(json['data']);
      userResponse = UserResponse(json['status'], json['message'], user);
    } catch (e) {
      userResponse = UserResponse.error(json['status'], e.toString());
    }
    return userResponse;
  }

  @override
  String toString() {
    return "Data UserResponse : $status, $message";
  }
}

class User {
  late String id;
  late String username;
  late String password;
  late String fullName;

  User(this.id, this.username, this.password, this.fullName);

  User.profile(this.id, this.username);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'], json['username'], json['password'], json['full_nm']);
  }

  @override
  String toString() {
    return "Data user logged in : $id, $username, $password, $fullName";
  }
}
