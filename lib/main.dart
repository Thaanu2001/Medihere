import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medihere/screens/welcome_screen.dart';
import 'package:medihere/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medihere/sharedData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MediHere());
}

class MediHere extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Color(0xffececec),
        accentColor: SharedData.mainColor,
      ),
      home: AuthService().handleAuth(),
    );
  }
}
