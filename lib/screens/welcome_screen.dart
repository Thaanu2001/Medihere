import 'package:flutter/material.dart';
import 'package:medihere/screens/home_screen.dart';

import 'package:medihere/screens/sign_up_screen.dart';
import 'package:medihere/sharedData.dart';
import 'package:medihere/transitions/sliding_transition.dart';
import 'package:medihere/widgets/bottom_menu_bar.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedData.mainColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              //* Logo -------------------------------------------------------------------------------------------
              margin: EdgeInsets.fromLTRB(80, 60, 80, 0),
              child: Image.asset('lib/assets/logo.png'),
            ),
            Expanded(
              //* Image -----------------------------------------------------------------------------------------
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(60, 0, 60, 20),
                    child: Image.asset('lib/assets/welcome_screen_image.png'),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Lorem ipsum dolor\nsit amet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'sf',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      //width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //* Get Started Button ----------------------------------------------------------------------------------
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: RaisedButton(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        'Get Started',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                        //width: double.infinity,
                      ),
                    ),
                    elevation: 5,
                    highlightColor: Color(0xff101010),
                    color: Colors.black,
                    padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    onPressed: () {
                      Route route = SlidingTransition(widget: SignUpScreen());
                      Navigator.push(context, route);
                    },
                  ),
                ),
                // Container(
                //   //* Log In Button ----------------------------------------------------------------------------------
                //   alignment: Alignment.bottomCenter,
                //   margin: EdgeInsets.fromLTRB(20, 8, 20, 30),
                //   child: RaisedButton(
                //     child: Container(
                //       width: double.infinity,
                //       child: Text(
                //         'Log In',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontFamily: 'sf',
                //             fontSize: 25,
                //             color: Colors.black,
                //             fontWeight: FontWeight.w500),
                //         //width: double.infinity,
                //       ),
                //     ),
                //     elevation: 4,
                //     highlightColor: Color(0xffcccccc),
                //     color: Colors.white,
                //     padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(15.0),
                //     ),
                //     onPressed: () {
                //       Route route = SlidingTransition(widget: BottomMenuBar());
                //       Navigator.push(context, route);
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
