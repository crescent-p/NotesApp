import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';

import 'Pages/MAINPage.dart';
import 'Pages/verifyemail.dart';
import 'Pages/login.dart';
import 'Pages/register.dart';
import 'package:friends2/consts/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthServices.firebase().initialize();
  runApp(
    MaterialApp(
      home: MAINpage(),
      routes: {
        loginView: (context) => const LoginView(),
        registerView: (context) => const Register(),
        mainView: (context) => const MAINpage(),
        verifyView: (context) => const VerficationPage(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthServices.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MAINpage();
              } else {
                return const VerficationPage();
              }
            } else {
              return const Register();
            }
          default:
            return const Text("loading");
        }
      },
    );
  }
}
