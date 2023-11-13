import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {

  /*
 final Order order;
  CartScreen({required this.order});
 */

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text(
            'Orders',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}