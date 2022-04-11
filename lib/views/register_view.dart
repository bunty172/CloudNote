import 'package:cloudnote/bloc/auth_bloc.dart';
import 'package:cloudnote/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_event.dart';
import '../dialogs/autherror_dialog.dart';
import '../dialogs/verificationemail_dialog.dart';
import '../firebase/firebase_exceptions.dart';
import '../loadingscreens/loadingscreen.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistered) {
          await showverificationEmailSent(context,
              "A verification Email link has been sent to your Email,Kindly verify your email or You can Login Now");
        }
        if (state is AuthStateNotRegistered) {
          if (state.exception is InvalidEmailException) {
            await showAuthErrorDialog(context, "Please Enter a valid email");
          } else if (state.exception is AlreadyRegisteredException) {
            await showAuthErrorDialog(context, "User already exists");
          } else if (state.exception is WeakPasswordExeption) {
            await showAuthErrorDialog(context, "Password is too weak");
          } else if (state.exception is GenericException) {
            await showAuthErrorDialog(context, "Something Went Wrong");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
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
                      .add(AuthEventRegister(email: email, password: password));
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLoggedOut());
                },
                child: const Text(
                  "Already Registered? Login now",
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
