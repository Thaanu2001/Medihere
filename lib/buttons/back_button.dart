import 'package:flutter/material.dart';

class BackActionButton extends StatelessWidget {
  final GestureTapCallback onPressed;

  BackActionButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: new Container(
        width: 42,
        height: 42,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              spreadRadius: 0.1,
              blurRadius: 5,
              offset: Offset(2.5, 2.5),
            )
          ],
          color: Color(0xff6b03a1),
          shape: BoxShape.circle,
        ),
        child: new Icon(Icons.arrow_left, color: Color(0xffffffff), size: 40.0),
      ),
    );
  }
}
