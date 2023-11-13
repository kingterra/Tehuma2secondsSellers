import 'package:flutter/material.dart';

import 'routes.dart';
import '../widgets/NavigationBar.dart';

class InitialScreen extends StatefulWidget {

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}
class _InitialScreenState extends State<InitialScreen> {

  int index = 0;
  BNavigationBar ?myBNB;

  void initState() {
    myBNB = BNavigationBar(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

@override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: myBNB,
      body: Routes(index: index),
  );
  }
}