import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String email;
  final bool isEmailVerified;
  final String userId;

  AuthUser({
    required this.userId,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      email: user.email!,
      isEmailVerified: user.emailVerified,
      userId: user.uid,
    );
  }
}
