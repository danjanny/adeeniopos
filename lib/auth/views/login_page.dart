import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black54)),
          )),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('Masuk',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 30),
              child: RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black54, height: 1.5),
                      children: [
                        TextSpan(
                            text:
                                "Masuk dengan email anda untuk memperoleh informasi terbaik dari aplikasi kami "),
                      ])),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 1. form email
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: "Email",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.55)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.indigo, width: 0.70))),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              // button event listener
                            },
                            child: const Text('Masuk',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 50),
                      child: Row(
                        children: const [
                          Expanded(
                              child: Divider(
                                  color: Colors.black54, endIndent: 10)),
                          Text(" Atau masuk dengan ",
                              style: TextStyle(color: Colors.black54)),
                          Expanded(
                              child:
                                  Divider(color: Colors.black54, indent: 10)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: const Icon(Ionicons.logo_google,
                            color: Colors.white),
                        onPressed: () {
                          // button event listener
                        },
                        label: const Text('Google',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email wajib diisi";
    } else {
      return null;
    }
  }
}
