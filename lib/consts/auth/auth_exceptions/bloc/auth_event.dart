abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventLogIn(this.email, this.password);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  AuthEventRegister(this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventResetPassword extends AuthEvent {
  final String? email;
  const AuthEventResetPassword(this.email);
}
