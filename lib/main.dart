import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Pages/verifyemail.dart';
import 'dialog_box/show_logout_dialog.dart';
import 'firebase_options.dart';
import 'Pages/login.dart';
import 'Pages/register.dart';
import 'dart:developer' as somename show log;
import 'package:friends2/consts/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: HomePage(),
      routes: {
        loginView: (context) => const LoginPage(),
        registerView: (context) => const Register(),
        mainView: (context) => const MAINpage(),
        verifyView: (context) => const VerficationPage(),
      },
    ),
  );
}

enum MINEEE { logout }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if (user != null) {
              if (user.emailVerified) {
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

class MAINpage extends StatefulWidget {
  const MAINpage({super.key});

  @override
  State<MAINpage> createState() => _MAINpageState();
}

class _MAINpageState extends State<MAINpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAIN UI'),
        actions: [
          PopupMenuButton<MINEEE>(
            onSelected: (value) async {
              switch (value) {
                case MINEEE.logout:
                  final somename1 = await showLogoutDialog(context);
                  if (somename1) {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                  somename.log(somename1.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MINEEE>(
                    value: MINEEE.logout, child: Text('Logout')),
              ];
            },
          )
        ],
      ),
      body: const Text('HEllo'),
    );
  }
}
