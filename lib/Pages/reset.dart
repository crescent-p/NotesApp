import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_event.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_state.dart';
import 'package:friends2/dialog_box/password_reset_dialog_box.dart';
import 'package:friends2/dialog_box/show_error_dialog.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateResetPassword) {
          if (state.emailSent == true) {
            _controller.clear();
            await passwordResetDialogBox(context: context);
          } else if (state.exception != null) {
            showErrorDialog(
                content: "Sorry We Couldn't process your request",
                context: context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reset Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text("Email"),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email Here"),
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(AuthEventResetPassword(_controller.text));
                  },
                  child: const Text("Reset Password")),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: const Text("Go to Login Page"))
            ],
          ),
        ),
      ),
    );
  }
}
