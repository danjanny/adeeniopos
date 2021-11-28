import 'package:app/auth/provider/auth_provider.dart';
import 'package:app/auth/provider/login_provider.dart';
import 'package:app/auth/providers/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black54))),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text('Selamat Datang',
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
                            style:
                                TextStyle(color: Colors.black54, height: 1.5),
                            children: [
                              TextSpan(
                                  text:
                                      "Daftarkan email anda untuk memperoleh informasi terbaik dari aplikasi kami "),
                            ])),
                  )
                ],
              ),
            ),
            Flexible(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 1. form email
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                  // ProgressDialog pd = ProgressDialog(context: context);
                                  // pd.show(
                                  //   msqFontWeight: FontWeight.normal,
                                  //   valuePosition: ValuePosition.right,
                                  //   borderRadius: 0,
                                  //   max: 100,
                                  //   msg: "Signing In",
                                  // );

                                },
                                child: const Text('Daftar',
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
                        Row(
                          children: const [
                            Expanded(
                                child: Divider(
                                    color: Colors.black54, endIndent: 10)),
                            Text(" Atau daftar dengan ",
                                style: TextStyle(color: Colors.black54)),
                            Expanded(
                                child:
                                    Divider(color: Colors.black54, indent: 10)),
                          ],
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
                )),
            Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black54, height: 1.5),
                          children: [
                            const TextSpan(
                                text: "Dengan mendaftar saya menyetujui "),
                            TextSpan(
                                text: "Syarat & Ketentuan",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Syarat dan ketentuan');
                                  }),
                            const TextSpan(text: " dan "),
                            TextSpan(
                                text: "Kebijakan Privasi App",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print('privacy policy')),
                          ])),
                ))
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
