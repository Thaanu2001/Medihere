import 'package:flutter/material.dart';
import 'package:medihere/sharedData.dart';
import 'package:quiver/async.dart';
import 'package:medihere/buttons/back_button.dart';
import 'package:medihere/screens/sign_up_screen.dart';
import 'package:medihere/services/auth_service.dart';
import 'package:medihere/widgets/dismiss_keyboard.dart';

class VerifyNumberScreen extends StatefulWidget {
  final String verificationId, name, phoneNo;
  VerifyNumberScreen(
      {@required this.verificationId,
      @required this.name,
      @required this.phoneNo});

  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  String smsCode;
  // int _start = 30;
  // int _current = 10;
  // bool resend = false;

  // void startTimer() {
  //   CountdownTimer countDownTimer = new CountdownTimer(
  //     new Duration(seconds: _start),
  //     new Duration(seconds: 1),
  //   );

  //   var sub = countDownTimer.listen(null);
  //   sub.onData((duration) {
  //     setState(() {
  //       _current = _start - duration.elapsed.inSeconds;
  //     });
  //   });

  //   sub.onDone(() {
  //     print("Done");
  //     setState(() {
  //       resend = true;
  //     });
  //     sub.cancel();
  //   });
  // }

  // @override
  // void initState() {
  //   startTimer();
  //   super.initState();
  // }

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
              padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Please enter 6-digit code sent to you  at ${widget.phoneNo}.',
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
                maxLength: 6,
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
                        new BorderSide(color: SharedData.mainColor, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: SharedData.mainColor, width: 2),
                  ),
                ),
                onChanged: (value) {
                  this.smsCode = value;
                },
              ),
            ),
            // (!resend)
            //     ? Container(
            //         //* Security Key Text ---------------------------------------------------------------------------------
            //         padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
            //         alignment: Alignment.topLeft,
            //         child: Text(
            //           'Resend code in $_current',
            //           style: TextStyle(
            //               fontFamily: 'sf',
            //               fontSize: 15,
            //               color: Colors.grey[800],
            //               fontWeight: FontWeight.w400),
            //         ),
            //       )
            //     : Container(
            //         //* Security Key Text ---------------------------------------------------------------------------------
            //         padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
            //         alignment: Alignment.topLeft,
            //         child: InkWell(
            //           onTap: () {
            //             print(widget.phoneNo);
            //             SignUpScreenState().verifyPhone(widget.phoneNo);
            //           },
            //           child: Text(
            //             'I haven’t recieved the code',
            //             style: TextStyle(
            //                 fontFamily: 'sf',
            //                 fontSize: 15,
            //                 color: SharedData.mainColor,
            //                 fontWeight: FontWeight.w400),
            //           ),
            //         ),
            //       ),
            Container(
              //* Continue Button ----------------------------------------------------------------------------------
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
                color: SharedData.mainColor,
                padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
                onPressed: () {
                  dismissKeyboard(context);
                  print(smsCode);
                  AuthService().signInWithOTP(smsCode, widget.verificationId,
                      context, widget.name, widget.phoneNo);
                  // Route route = SlidingTransition(widget: VerifyNumberScreen());
                  // Navigator.push(context, route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
