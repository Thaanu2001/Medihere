import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medihere/screens/home_screen.dart';
import 'package:medihere/screens/welcome_screen.dart';
import 'package:medihere/transitions/sliding_transition.dart';
import 'package:medihere/widgets/bottom_menu_bar.dart';

class AuthService {
  //* Handles Auth
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return BottomMenuBar();
        } else {
          return WelcomeScreen();
        }
      },
    );
  }

  //* Sign Out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //* Sign in
  signIn(AuthCredential authCreds, context) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    print('Signed In');

    registerUser();

    Route route = SlidingTransition(widget: BottomMenuBar());
    Navigator.pushAndRemoveUntil(
        context, route, (Route<dynamic> route) => false);
  }

  //* Sign in with OTP
  signInWithOTP(smsCode, verId, context) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds, context);
  }

  //* Register user into firestore
  registerUser() {}
}
