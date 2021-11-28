import 'package:app/auth/views/welcome_page.dart';
import 'package:app/auth/providers/auth_provider.dart';
import 'package:app/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/provider/auth_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider.instance(),
      child: MaterialApp(
          title: 'My App',
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: Consumer<AuthProvider>(builder: (_, authProvider, __) {
            switch (authProvider.status) {
              case Status.Authenticated:
                // User logged in  : Widget Dashboard
                return Scaffold(
                  appBar: AppBar(title: const Text('Dashboard Page')),
                  body: Container(
                      alignment: Alignment.center,
                      child: const Text('Dashboard Page')),
                );
              case Status.FirstInitialized:
                // first init app launch
                return const OnboardingPage();
              default:
                // User not logged in : show welcome page login, registration
                return const WelcomePage();
            }
          })),
    );
  }
}
