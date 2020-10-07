import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              //* Topic Text ---------------------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 45, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Pharmacies near you',
                style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //* Location Change button ---------------------------------------------------------------------------------
              padding: EdgeInsets.fromLTRB(30, 2, 0, 0),
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Text(
                  'Change your location',
                  style: TextStyle(
                      fontFamily: 'sf',
                      fontSize: 15,
                      color: Color(0xff3b53e5),
                      fontWeight: FontWeight.w400),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
