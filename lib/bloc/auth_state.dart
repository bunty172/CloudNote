

abstract class AuthState {
  final bool isLoading;
  const AuthState({required this.isLoading});
}

class AuthStateInitialState extends AuthState  {
  const AuthStateInitialState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistered extends AuthState {
  const AuthStateRegistered({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateShouldRegister extends AuthState {
  const AuthStateShouldRegister({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateShouldResetPassword extends AuthState {
  const AuthStateShouldResetPassword({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateNotRegistered extends AuthState {
  final Exception? exception;
  const AuthStateNotRegistered(
      {required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
}

class AuthStateCannotReset extends AuthState {
  final Exception exception;
  const AuthStateCannotReset({required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
}

class AuthStateNotLoggedIn extends AuthState  {
  final Exception? exception;
  const AuthStateNotLoggedIn({required bool isLoading, required this.exception})
      : super(isLoading: isLoading);

}
