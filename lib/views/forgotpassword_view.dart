import 'package:cloudnote/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../dialogs/autherror_dialog.dart';
import '../firebase/firebase_exceptions.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateCannotReset) {
          if (state.exception is InvalidEmailException) {
            await showAuthErrorDialog(context, "Please enter a valid email");
          } else if (state.exception is UserNotFoundException) {
            await showAuthErrorDialog(context, "User does not exist");
          } else {
            await showAuthErrorDialog(context, "Something went Wrong");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Reset Password")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text(
              "Please Enter Your email:",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Enter your email"),
              controller: _controller,
            ),
            TextButton(
                onPressed: () async {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(AuthEventForgotPassword(
                        email: email,
                      ));
                },
                child: const Text(
                  "Send reset link",
                  style: TextStyle(fontSize: 20),
                )),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLoggedOut());
                },
                child: const Text(
                  "Back to Login Page",
                  style: TextStyle(fontSize: 20),
                ))
          ]),
        ),
      ),
    );
  }
}
