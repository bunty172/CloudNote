import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloudnote/bloc/auth_bloc.dart';
import 'package:cloudnote/bloc/auth_event.dart';
import 'package:cloudnote/bloc/auth_state.dart';
import 'package:cloudnote/constants/routes.dart';
import 'package:cloudnote/firebase/firebaseauth_provider.dart';
import 'package:cloudnote/loadingscreens/loadingscreen.dart';
import 'package:cloudnote/views/forgotpassword_view.dart';
import 'package:cloudnote/views/login_view.dart';
import 'package:cloudnote/views/notes_view.dart';
import 'package:cloudnote/views/register_view.dart';
import 'package:cloudnote/views/takenote_view.dart';
import 'package:cloudnote/views/updatenote_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      title: "CloudNote",
      home: AnimatedSplashScreen(
        splash: const Icon(Icons.book,size: 100.0,),
        backgroundColor: Colors.blueGrey,
        animationDuration: const Duration(seconds: 3),
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const Homepage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        takenoteRoute: (context) => const TakeNoteView(),
        updatenoteRoute: (context) => const UpdateNoteView(),
        loginRoute: ((context) => const LoginView())
      },
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final LoadingScreen loadingScreen;

  @override
  void initState() {
    loadingScreen = LoadingScreen(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          loadingScreen.showOverlay();
        } else {
          loadingScreen.removeOverlay();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistered) {
          return const LoginView();
        } else if (state is AuthStateShouldRegister) {
          return const RegisterView();
        } else if (state is AuthStateNotLoggedIn) {
          return const LoginView();
        } else if (state is AuthStateNotRegistered) {
          return const RegisterView();
        } else if (state is AuthStateShouldResetPassword) {
          return const ForgotPasswordView();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
