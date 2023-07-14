
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerficationPage extends StatefulWidget {
  const VerficationPage({super.key});

  @override
  State<VerficationPage> createState() => _VerficationPageState();
}

class _VerficationPageState extends State<VerficationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("please press the button below to verify your email"),
        TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              user?.sendEmailVerification();
            },
            child: Text('verify Email')),
      ],
    );
  }
}
