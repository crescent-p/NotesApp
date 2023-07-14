import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      appBar: AppBar(title: Text('REIGSTER HERE')),
      body: Column(
        children: [
          FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
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
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);

                            print(userdetails);
                          } catch (e) {
                            print(e.runtimeType);
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  );
                default:
                  return const Text('loading');
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              child: const Text('Login Here!'))
        ],
      ),
    );
  }
}
