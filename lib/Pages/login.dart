import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/login_exceptions.dart';
import 'package:friends2/consts/routes.dart';
import 'package:friends2/dialog_box/show_error_dialog.dart';
import '../consts/auth/auth_exceptions/auth_services.dart';
import '../consts/auth/auth_exceptions/bloc/auth_bloc.dart';
import '../consts/auth/auth_exceptions/bloc/auth_event.dart';
import '../consts/auth/auth_exceptions/bloc/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(
                    content: 'User not found',
                    context: context,
                  );
                } else if (state is WrongPasswordAuthException) {
                  await showErrorDialog(
                    content: "Wrong Credentials",
                    context: context,
                  );
                } else if (state is GenericAuthException) {
                  await showErrorDialog(
                    content: "Authentication Error",
                    context: context,
                  );
                }
              }
            },
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogIn(
                      email,
                      password,
                    ));
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerView,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
