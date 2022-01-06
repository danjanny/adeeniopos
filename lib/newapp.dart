import 'package:app/authnew/repos/auth_repository.dart';
import 'package:app/authpos/models/user_model.dart';
import 'package:app/authpos/views/login_page.dart';
import 'package:app/order/views/product_page.dart';
import 'package:app/order/views/report_page.dart';
import 'package:flutter/material.dart';

class NewApp extends StatelessWidget {
  const NewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS',
      routes: {'/login': (context) => LoginPage()},
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: const Color(0xff3958B4)),
      home: FutureBuilder(
        future: AuthRepository.checkUserSession(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            late Widget nextScreen;
            var userObj = snapshot.data as User;
            if (!snapshot.hasData) {
              nextScreen = LoginPage();
            } else {
              // kasir
              if (userObj.idGroupAccess == "2") {
                nextScreen = ProductPage(user: userObj);
                // admin
              } else if (userObj.idGroupAccess == "1") {
                nextScreen = ReportPage(user: userObj);
              }
            }
            return nextScreen;
          }
        },
      ),
    );
  }
}
