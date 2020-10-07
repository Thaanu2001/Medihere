import 'package:flutter/material.dart';
import 'package:medihere/screens/welcome_screen.dart';
import 'package:medihere/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MediHere());
}

class MediHere extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Color(0xfff9f9f9),
        accentColor: Color(0xff3b53e5),
      ),
      home: AuthService().handleAuth(),
    );
  }
}
