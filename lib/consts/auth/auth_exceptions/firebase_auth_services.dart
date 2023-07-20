import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_provider.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_user.dart';
import 'package:friends2/consts/auth/auth_exceptions/login_exceptions.dart';
import '../../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedIn();
      }
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      final user = currentUser;
      if (user != null) {
        await FirebaseAuth.instance.signOut();
      } else {
        throw UserNotLoggedIn();
      }
    } catch (_) {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> sendEmailVerificaton() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification();
    } else {
      throw UserNotLoggedIn;
    }
  }

  @override
  Future<void> logInUser(
      {required String email, required String password}) async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        print(e);
        throw Exception();
      }
    } else {
      throw UserNotFoundAuthException();
    }
  }
}
