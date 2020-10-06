import 'package:flutter/material.dart';
import 'package:medihere/buttons/back_button.dart';
import 'package:medihere/transitions/sliding_transition.dart';
import 'package:medihere/widgets/dismiss_keyboard.dart';

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
            ),
            Container(
              //* Security Key Text ---------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Please enter 4-digit code sent to you  at 077 123 4567.',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //* Security Key TextField ---------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              alignment: Alignment.topLeft,
              child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
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
              //* Security Key Text ---------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  print('bls');
                },
                child: Text(
                  'I haven’t recieved the code',
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 15,
                      color: Color(0xff3b53e5),
                      fontWeight: FontWeight.w400),
                ),
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
