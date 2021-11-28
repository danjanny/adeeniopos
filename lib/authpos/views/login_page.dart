import 'package:app/authpos/models/user_model.dart';
import 'package:app/authpos/providers/auth_provider.dart';
import 'package:app/order/views/product_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late ProgressDialog _pd;
  final _usernameFormController = TextEditingController();
  final _passwordFormController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:
                  Image.asset('assets/mzn_color.png', width: 250, height: 250),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _usernameFormController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Username harus diisi",
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(Icons.person),
                              ),
                              labelText: 'Username'),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Username harus diisi';
                            }
                            return null;
                          }),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _passwordFormController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password harus diisi",
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(Icons.lock),
                              ),
                              labelText: 'Password'),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password harus diisi';
                            }
                            return null;
                          }),
                      const SizedBox(height: 25),
                      SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              processLogin(context);
                            },
                            child: const Text('Log in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            // style: ElevatedButton.styleFrom(
                            //     primary: Colors.indigoAccent),
                          ),
                          width: double.infinity,
                          height: 50),
                    ],
                  )
              ),
            ))
          ],
        ),
      ),
    );
  }

  void processLogin(BuildContext context) async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }

    _pd = ProgressDialog(context: context);
    _pd.show(
      msqFontWeight: FontWeight.normal,
      valuePosition: ValuePosition.right,
      borderRadius: 0,
      max: 100,
      barrierDismissible: true,
      msg: "Logging In",
    );

    var username = _usernameFormController.text;
    var password = _passwordFormController.text;
    var userResponse = await AuthProvider.userLogin(username, password);
    _pd.close();

    if (userResponse!.status == 'ok') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductPage()));
    } else {
      Fluttertoast.showToast(msg: userResponse.message);
    }
  }
}
