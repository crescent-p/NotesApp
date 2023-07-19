import 'package:firebase_core/firebase_core.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_provider.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_user.dart';
import 'package:friends2/firebase_options.dart';
import 'firebase_auth_services.dart';

class AuthServices implements FirebaseAuthProvider {
  final FirebaseAuthProvider provider;

  AuthServices(this.provider);
  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    return provider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailVerificaton() {
    return provider.sendEmailVerificaton();
  }

  @override
  Future<void> initialize() async {
    provider.initialize();
  }

  @override
  Future<void> logInUser(
      {required String email, required String password}) async {
    provider.logInUser(email: email, password: password);
  }
}