import 'package:app/authnew/repos/auth_repository.dart';
import 'package:app/authnew/views/welcome_page.dart';
import 'package:app/authpos/views/login_page.dart';
import 'package:app/dashboard/views/home_page.dart';
import 'package:app/order/views/product_page.dart';
import 'package:flutter/material.dart';

class NewApp extends StatelessWidget {
  const NewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mezisan POS',
      routes: {'/login': (context) => LoginPage()},
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xff00365A)
      ),
      home: FutureBuilder(
        future: AuthRepository.checkUserSession(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data != 1) {
              // belum ada user session
              return LoginPage();
            } else {
              // sudah ada user session
              return ProductPage();
            }
          }
        },
      ),
    );
  }
}
