import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerificaton();
}
