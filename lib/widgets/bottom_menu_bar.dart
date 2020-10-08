import 'package:flutter/material.dart';
import 'package:medihere/screens/home_screen.dart';
import 'package:medihere/screens/orders_screen.dart';
import 'package:medihere/screens/profile_screen.dart';

class BottomMenuBar extends StatefulWidget {
  @override
  _BottomMenuBarState createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    OrdersScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ), // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          onTabTapped(value);
        }, // new
        backgroundColor: Color(0xFFe6e9f8),
        selectedItemColor: Color(0xff3b53e5),
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          new BottomNavigationBarItem(
              icon: Icon(Icons.receipt_rounded), label: 'Orders'),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    print(index);
    setState(() {
      _currentIndex = index;
    });
  }
}
