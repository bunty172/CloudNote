import 'package:cloudnote/bloc/auth_bloc.dart';
import 'package:cloudnote/bloc/auth_event.dart';
import 'package:cloudnote/bloc/auth_state.dart';
import 'package:cloudnote/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dialogs/autherror_dialog.dart';
import '../firebase/firebase_exceptions.dart';
import '../loadingscreens/loadingscreen.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final LoadingScreen loadingScreen;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    loadingScreen = LoadingScreen(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNotLoggedIn && state.exception != null) {
          if (state.exception is UserNotFoundException) {
            await showAuthErrorDialog(context, "User not found");
          } else if (state.exception is WrongPasswordException) {
            await showAuthErrorDialog(context, "Password is incorrect");
          } else if (state.exception is InvalidEmailException) {
            await showAuthErrorDialog(context, "Please enter a valid email");
          } else {
            await showAuthErrorDialog(context, "Something Went Wrong");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter Your Email",
                ),
                controller: _email,
                autofocus: true,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter Your Password",
                ),
                controller: _password,
                obscureText: true,
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventLogin(email: email, password: password));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text(
                  "Haven't Registered Yet?",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventShouldResetPassword());
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
