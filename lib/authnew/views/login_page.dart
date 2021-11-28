import 'package:app/authnew/models/user_model.dart';
import 'package:app/authnew/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  late ProgressDialog _pd;

  final _formKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Scaffold(
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
        resizeToAvoidBottomInset: false,
        body: Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            // color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        // color: Colors.blueAccent,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Selamat Datang!',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20)),
                            Column(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.email),
                                        hintText: "Email",
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 0.55)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.indigo,
                                                width: 0.70))),
                                    validator: _validateEmail,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Consumer<AuthProvider>(
                                      builder: (_, authProvider, __) {
                                        return OutlinedButton(
                                          onPressed: () {
                                            _processRegistration(
                                                authProvider, context);
                                          },
                                          child: const Text('Masuk',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.deepOrange),
                                        );
                                      },
                                    ))
                              ],
                            ),
                            Row(
                              children: const [
                                Expanded(
                                    child: Divider(
                                        color: Colors.black54, endIndent: 10)),
                                Text(" Atau masuk dengan ",
                                    style: TextStyle(color: Colors.black54)),
                                Expanded(
                                    child: Divider(
                                        color: Colors.black54, indent: 10)),
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
                        ))),
                Expanded(child: Container(alignment: Alignment.center))
              ],
            )),
      ),
    );
  }

  /// if null, data valid
  String? _validateEmail(String? value) {
    _pd.close();

    if (value!.isEmpty) {
      return "Email wajib diisi";
    }

    final regex = RegExp('[^@]+@[^\.]+\..+');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  void _processRegistration(
      AuthProvider authProvider, BuildContext context) async {
    _pd = ProgressDialog(context: context);
    _pd.show(
      msqFontWeight: FontWeight.normal,
      valuePosition: ValuePosition.right,
      borderRadius: 0,
      max: 100,
      msg: "Signing In",
    );

    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }

    var email = _emailController.text.replaceAll(' ', '');
    var userResponse = await authProvider.checkEmail(email);

    switch (authProvider.statusUser) {
      case StatusUser.userHasNotRegistered:
        // go to UserVerificationPage();
        break;
      case StatusUser.userHasRegistered:
        // go to UserVerificationPage(userResponse);
        break;
      case StatusUser.authServerError:
        // error occured in the server
        await _showAlertDialog(context, userResponse);
        break;
      default:
        // error occured in client
        await _showAlertDialog(context, userResponse);
        print(userResponse.toString());
        break;
    }

    _pd.close();
  }

  Future<void> _showAlertDialog(
      BuildContext context, UserResponse? userResponse) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(userResponse!.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          );
        });
  }
}
