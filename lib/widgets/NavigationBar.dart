import 'package:flutter/material.dart';


class BNavigationBar extends StatefulWidget {

  final Function currentIndex;
  const BNavigationBar ({Key? key, required this.currentIndex}) : super(key: key);

  @override
   _BNavigationBarState createState() => _BNavigationBarState();
}

class _BNavigationBarState extends State<BNavigationBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {

      return BottomNavigationBar(
        currentIndex: index,
        onTap: (int i) {
          setState(() {
            index = i;
            widget.currentIndex(i);
          });
        },
        unselectedItemColor: Colors.grey.shade500,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.mail),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
          selectedItemColor: Colors.black,
        );
  }
}

