import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends2/consts/routes.dart';

class VerficationPage extends StatefulWidget {
  const VerficationPage({super.key});

  @override
  State<VerficationPage> createState() => _VerficationPageState();
}

class _VerficationPageState extends State<VerficationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email!')),
      body: Column(
        children: [
          const Text("Please Check your email to verify"),
          const Text(
              "If you haven't received an email click the button below."),
          TextButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
              },
              child: const Text('Resend Email Verification')),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, registerView, (route) => false);
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
