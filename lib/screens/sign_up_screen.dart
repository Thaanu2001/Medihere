import 'package:flutter/material.dart';
import 'package:medihere/buttons/back_button.dart';
import 'package:medihere/screens/verify_number_screen.dart';
import 'package:medihere/transitions/sliding_transition.dart';
import 'package:medihere/widgets/dismiss_keyboard.dart';

class SignUpScreen extends StatelessWidget {
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
            ),
            Container(
              //* Name Text ----------------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Name',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //* Name TextField -----------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 4, 30, 0),
              alignment: Alignment.topLeft,
              child: TextField(
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: Color(0xffebedfc),
                  focusColor: Colors.red,
                  counter: SizedBox.shrink(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color(0xff3b53e5), width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color(0xff3b53e5), width: 2),
                  ),
                ),
              ),
            ),
            Container(
              //* Contact Number Text -------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Mobile Number',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //* Contact Number TextField ------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 4, 30, 0),
              alignment: Alignment.topLeft,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: Color(0xffebedfc),
                  focusColor: Colors.red,
                  counter: SizedBox.shrink(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color(0xff3b53e5), width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color(0xff3b53e5), width: 2),
                  ),
                ),
              ),
            ),
            Container(
              //* Contact Number Text -------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'By continuing you may recieve an SMS for verification. Message and data rates may apply.',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //* Sign Up Button ----------------------------------------------------------------------------------
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(30, 20, 30, 8),
              child: RaisedButton(
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'sf',
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    //width: double.infinity,
                  ),
                ),
                elevation: 4,
                highlightColor: Color(0xff4b62ed),
                color: Color(0xff3b53e5),
                padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
                onPressed: () {
                  dismissKeyboard(context);
                  Route route = SlidingTransition(widget: VerifyNumberScreen());
                  Navigator.push(context, route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
