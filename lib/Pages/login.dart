import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          title: Title(
            color: Colors.black,
            child: const Text('Registration Screen'),
          ),
        ),
        body: FutureBuilder(
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
                        // controller: _password,
                        decoration: const InputDecoration(
                            hintText: 'Enter your soul or die'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _username.text;
                          final password = _password.text;
                          try {
                            final userdetails = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            print(userdetails);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'wrong-password')
                              print("The given password was wrong");
                            if (e.code == 'user-not-found')
                              print("The given UserName is not registered!");
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                );
              default:
                return const Text('Login Page');
            }
          },
        ));
  }
}
