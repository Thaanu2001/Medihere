import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  signIn(AuthCredential authCreds, context, name, phoneNo) async {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    print('Signed In');

    registerUser(name, phoneNo);
    setDisplayName(name);

    Route route = SlidingTransition(widget: BottomMenuBar());
    Navigator.pushAndRemoveUntil(
        context, route, (Route<dynamic> route) => false);
  }

  //* Sign in with OTP
  signInWithOTP(smsCode, verId, context, name, phoneNo) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds, context, name, phoneNo);
  }

  //* Register user into firestore
  registerUser(name, phoneNo) {
    FirebaseFirestore.instance
        .collection("users")
        .doc("$phoneNo")
        .set({'name': '$name', 'phone-number': '$phoneNo'});
  }

  setDisplayName(name) async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
      } else {
        user.updateProfile(displayName: name);
      }
    });
  }
}
