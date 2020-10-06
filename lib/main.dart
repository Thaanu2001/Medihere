import 'package:flutter/material.dart';
import 'package:medihere/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: Color(0xfff9f9f9),
          accentColor: Color(0xff3b53e5)),
      home: WelcomeScreen(),
    );
  }
}
