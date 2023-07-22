import 'package:flutter/material.dart';
import 'package:friends2/consts/routes.dart';
import 'package:friends2/dialog_box/show_error_dialog.dart';
import '../consts/auth/auth_exceptions/auth_services.dart';

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
            future: AuthServices.firebase().initialize(),
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
                            await AuthServices.firebase()
                                .createUser(email: email, password: password);
                            await AuthServices.firebase()
                                .sendEmailVerificaton();
                            Navigator.pushNamed(context, verifyView);
                          } catch (e) {
                            showErrorDialog(
                                content: e.toString(), context: context);
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
                    context, loginView, (route) => false);
              },
              child: const Text('Login Here!'))
        ],
      ),
    );
  }
}
