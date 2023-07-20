import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;

  const AuthUser({
    required this.isEmailVerified,
    required this.email,
  });

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(email: user.email, isEmailVerified: user.emailVerified);
}
