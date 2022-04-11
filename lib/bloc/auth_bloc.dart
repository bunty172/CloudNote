import 'package:bloc/bloc.dart';
import 'package:cloudnote/bloc/auth_state.dart';
import 'package:cloudnote/firebase/firebaseauth_provider.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(FirebaseAuthProvider firebaseAuthProvider)
      : super(const AuthStateInitialState(isLoading: false)) {
    on<AuthEventInitialize>((event, emit) async {
      await firebaseAuthProvider.initializeFirebase();
      final user = firebaseAuthProvider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(isLoading: false));
      } else {
        emit(const AuthStateLoggedIn(isLoading: false));
      }
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(const AuthStateNotRegistered(exception: null, isLoading: true));
        await firebaseAuthProvider.createUser(
          email: email,
          password: password,
        );
        emit(const AuthStateRegistered(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateNotRegistered(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogin>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          emit(const AuthStateNotLoggedIn(isLoading: true, exception: null));
          await firebaseAuthProvider.login(
            email: email,
            password: password,
          );
          emit(const AuthStateLoggedIn(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateNotLoggedIn(isLoading: false, exception: e));
        }
      },
    );

    on<AuthEventForgotPassword>(
      (event, emit) async {
        final email = event.email;
        try {
          emit(const AuthStateNotRegistered(exception: null, isLoading: true));
          await firebaseAuthProvider.sendpasswordResetLink(email: email);
          emit(const AuthStateLoggedOut(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateNotRegistered(exception: e, isLoading: false));
        }
      },
    );

    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await firebaseAuthProvider.logout();
          emit(const AuthStateLoggedOut(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateNotLoggedIn(isLoading: false, exception: e));
        }
      },
    );

    on<AuthEventLoggedOut>(
      (event, emit) {
        emit(const AuthStateLoggedOut(isLoading: false));
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateShouldRegister(isLoading: false));
      },
    );
    on<AuthEventShouldResetPassword>(
      (event, emit) {
        emit(const AuthStateShouldResetPassword(isLoading: false));
      },
    );
  }
}
