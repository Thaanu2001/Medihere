import 'package:flutter/material.dart';
import 'package:medihere/buttons/back_button.dart';

class VerifyNumberScreen extends StatefulWidget {
  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              //* Back Button ------------------------------------------------------------------------------------
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 40, left: 20),
              child: BackActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
