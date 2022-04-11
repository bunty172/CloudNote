abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  AuthEventRegister({
    required this.email,
    required this.password,
  });
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  AuthEventLogin({
    required this.email,
    required this.password,
  });
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventForgotPassword extends AuthEvent {
  final String email;
  AuthEventForgotPassword({required this.email});
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventLoggedOut extends AuthEvent {
  const AuthEventLoggedOut();
}

class AuthEventShouldResetPassword extends AuthEvent {
  const AuthEventShouldResetPassword();
}

