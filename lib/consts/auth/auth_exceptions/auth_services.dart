import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_provider.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_user.dart';
import 'package:friends2/consts/auth/auth_exceptions/login_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  //returns AuthUser, the AuthUser.isEmailVerified function can be used
  //to get the email verification status.
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
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerificaton() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification;
    } else {
      throw UserNotLoggedIn;
    }
  }
}
