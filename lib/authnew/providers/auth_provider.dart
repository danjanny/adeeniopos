import 'dart:convert';
import 'dart:io';

import 'package:app/authnew/models/user_model.dart';
import 'package:app/constant.dart';
import 'package:app/simple_exception.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    notifyListeners();

    final googleAuth = await googleUser.authentication;
    final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await firebase.FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<firebase.User?> signInWithGoogle() async {
    firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;
    firebase.User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final firebase.AuthCredential credential =
        firebase.GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

    final firebase.UserCredential userCredential =
        await auth.signInWithCredential(credential);

    user = userCredential.user;

    return user;
  }

  Future<UserResponse?> checkEmail(String? email) async {
    UserResponse userResponse;
    try {
      var params = {'email': email};

      var checkUserEmailResponse = await http.post(
          Uri.parse(ApiEndpoint.checkUserEmail),
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
