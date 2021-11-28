import 'package:app/authnew/views/login_page.dart';
import 'package:app/authnew/views/signup_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(flex: 2, child: Image.asset('assets/img2.jpg')),
            Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: const Text('Masuk',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.indigoAccent),
                        ),
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 0.90, color: Colors.black54)),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => SignupPage()),
                              );
                            },
                            child: const Text('Belum punya akun ? Daftar Yuk !',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
