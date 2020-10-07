import 'package:flutter/material.dart';
import 'package:medihere/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        onPressed: () {
          setState(() {
            AuthService().signOut();
          });
        },
      ),
    );
  }
}
