import 'package:friends2/consts/auth/auth_exceptions/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendPasswordReset({required String email});
  Future<void> sendEmailVerificaton();
  Future<AuthUser> logInUser({
    required String email,
    required String password,
  });
}
