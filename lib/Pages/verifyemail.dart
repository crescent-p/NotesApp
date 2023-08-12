import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_event.dart';
import 'package:friends2/consts/routes.dart';

import '../consts/auth/auth_exceptions/auth_services.dart';

class VerficationPage extends StatefulWidget {
  const VerficationPage({super.key});

  @override
  State<VerficationPage> createState() => _VerficationPageState();
}

class _VerficationPageState extends State<VerficationPage> {
  @override
  Widget build(BuildContext context) {
    AuthServices.firebase().initialize();
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email!')),
      body: Column(
        children: [
          const Text("Please Check your email to verify"),
          const Text(
              "If you haven't received an email click the button below."),
          TextButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
              },
              child: const Text('Resend Email Verification')),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogout());
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
