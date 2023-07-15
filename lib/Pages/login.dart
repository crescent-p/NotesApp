import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../dialog_box/show_login_error.dart';
import '../firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _username;

  late final TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Column(
        children: [
          FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('UserName'),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorHeight: 1,
                          cursorColor: Colors.amber,
                          textAlign: TextAlign.center,
                          controller: _username,
                        ),
                        const Text('Password'),
                        TextField(
                          controller: _password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              hintText: 'Enter your soul or die'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final email = _username.text;
                            final password = _password.text;
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((value) {
                                final person =
                                    FirebaseAuth.instance.currentUser;
                                if (person?.emailVerified ?? false) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/main', (route) => false);
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/verify', (route) => false);
                                }
                              });
                            } catch (e) {
                              showLoginError(
                                context,
                                //#TODO replace text with widget
                                "Error: ${e.toString()}",
                              );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  );
                default:
                  return const Text('Login Page');
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/register', (route) => false);
              },
              child: const Text('Not Registerd? Register here'))
        ],
      ),
    );
  }
}
