import 'package:flutter/material.dart';
import 'package:medihere/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        onPressed: () => AuthService().signOut(),
      ),
    );
  }
}
