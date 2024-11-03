import 'package:Callability/src/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging_flutter/logging_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
    catch (exc, stackTrace) {
      if (context.mounted) {
        AlertMessageDialog(context).show(
            title: 'Login failed', message: '$exc');
        Flogger.e('Login failed: $exc\n$stackTrace', loggerName: 'LOGIN');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => signInWithGoogle(context),
        child: const Text('Log in with Google')
      ),
    );
  }

}