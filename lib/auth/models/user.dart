class UserResponse {
  late String status;
  late String statusLogin;
  late String message;
  late User user;

  UserResponse(
      {required this.status,
      required this.statusLogin,
      required this.message,
      required this.user});

  UserResponse.newUser(
      {required this.status, required this.statusLogin, required this.message});

  UserResponse.error({required this.status, required this.message});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    UserResponse userResponse;
    try {
      if (json['data'] == null) {
        // user belum terdaftar
        userResponse = UserResponse.newUser(
            status: json['status'],
            statusLogin: json['status_login'],
            message: json['message']);
      } else {
        // user sudah terdaftar
        var user = User.fromJson(json['data']);
        userResponse = UserResponse(
            status: json['status'],
            statusLogin: json['status_login'],
            message: json['message'],
            user: user);
      }
    } catch (e) {
      // error occured saat menerima respon dari server
      userResponse =
          UserResponse.error(status: json['status'], message: json['message']);
    }

    return userResponse;
  }
}

class User {
  String id;
  String email;
  String password;
  String fullName;
  String image;

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.fullName,
      required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        fullName: json['full_nm'],
        image: json['image']);
  }

  @override
  String toString() {
    return "Data user logged in : $id, $email, $password, $fullName, $image";
  }
}
