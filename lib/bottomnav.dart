import 'package:flutter/material.dart';
import 'package:quick_shop/supermarket.dart';

import 'feedback.dart';
import 'homepage.dart';
class MyNavigationBar extends StatefulWidget {
  MyNavigationBar ({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar > {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    SuperMarket(),
    Home(),
    Userfeedback(),
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
               label: 'supermarket',
                backgroundColor: Colors.teal
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.teal
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
             label: 'feedback',
              backgroundColor: Colors.teal,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Complaints',
              backgroundColor: Colors.teal,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );
  }
}
