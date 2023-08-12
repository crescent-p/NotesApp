import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_user.dart';

@immutable
abstract class AuthState {
  final String? loadingText;
  final bool isLoading;
  const AuthState(
      {this.loadingText = "Please wait...", required this.isLoading});
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(isLoading: isLoading, loadingText: loadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}
// class AuthStateLogoutFailure extends AuthState {
//   final Exception exception;

//   const AuthStateLogoutFailure(this.exception);
// }

class AuthStateEmailVerified extends AuthState {
  const AuthStateEmailVerified({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegister extends AuthState {
  const AuthStateRegister({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception exception;

  const AuthStateRegistering({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateResetPassword extends AuthState {
  final Exception? exception;
  final bool? emailSent;
  const AuthStateResetPassword({
    required this.exception,
    required this.emailSent,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}
