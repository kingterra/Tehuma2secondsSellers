import 'package:foodpanda_sellers_app/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';

import 'EarningsScreen.dart';
import 'OrdersScreen.dart';
import 'MenuScreen.dart';
import 'accountScreen.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      HomeScreen(),
      OrdersScreen(),
      EarningsScreen(),
      MenuScreen(),
      SettingsScreen(),
    ];
    return myList[index];
  }
}
