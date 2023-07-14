import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pages/verifyemail.dart';
import 'firebase_options.dart';
import 'Pages/login.dart';
import 'Pages/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => Register(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/register', (route) => false);
              },
              child: const Text('NEW here? Register here')),
          FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false)
                    print('verified');
                  else {
                    print('not verified');
                    return VerficationPage();
                  }

                  return Text("done");
                default:
                  return Text("loading");
              }
            },
          ),
        ],
      ),
    );
  }
}
