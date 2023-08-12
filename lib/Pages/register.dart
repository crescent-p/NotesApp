import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_event.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_state.dart';
import 'package:friends2/consts/auth/auth_exceptions/login_exceptions.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              content: "Weak Password",
              context: context,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              content: "Email Already in Use",
              context: context,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              content: "Invalid Email",
              context: context,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                content: "COuldn't Register", context: context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('REGiSTER HERE')),
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
                            context.read<AuthBloc>().add(AuthEventRegister(
                                  email,
                                  password,
                                ));
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
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text('Login Here!'))
          ],
        ),
      ),
    );
  }
}
