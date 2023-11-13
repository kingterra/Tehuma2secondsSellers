import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {

  final List<double> expenses;

  BarChart(this.expenses);

  @override
  Widget build(BuildContext context) {

    double mostExpensive = 0;
    expenses.forEach((double price) {
      if (price > mostExpensive) {
        mostExpensive = price;
      }
    });

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(
            'Weekly Earning',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 25.0,
                onPressed: () {},
              ),
              Text(
                'Nov 10, 2022 - Nov 16, 2022',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                )
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 25.0,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Bar(
                label: 'Mo',
                amountSpent: expenses[0],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Tu',
                amountSpent: expenses[1],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'We',
                amountSpent: expenses[2],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Th',
                amountSpent: expenses[3],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Fr',
                amountSpent: expenses[4],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Sa',
                amountSpent: expenses[5],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Su',
                amountSpent: expenses[6],
                mostExpensive: mostExpensive,
              ),
            ]
          )
        ],
      ),
    );
  }
}


class Bar extends StatelessWidget {

  final String label;
  final double amountSpent;
  final double mostExpensive;

  final double _maxBarHeight = 150.0;

  Bar({required this.label, required this.amountSpent, required this.mostExpensive});

  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpent / mostExpensive * _maxBarHeight;
    return Column(
      children: <Widget>[
        Text(
          '\$${amountSpent.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          )
        ),
        SizedBox(height: 6.0),
        Container(
          height: barHeight,
          width: 18.0,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]
    );
  }
}

