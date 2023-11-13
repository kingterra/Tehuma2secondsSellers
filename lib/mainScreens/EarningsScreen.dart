import 'package:flutter/material.dart';

import '../UdemyCourse/data.dart';
import '../widgets/bar_chart.dart';

class EarningsScreen extends StatefulWidget {

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.grey.shade100,
                forceElevated: true,
                //floating: true,
                pinned: true,
                expandedHeight: 100.0,
                leading: IconButton(
                  icon: Icon(Icons.settings),
                  iconSize: 30.0,
                  color: Colors.black,
                  onPressed: () {},
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Earnings',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 30.0,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: BarChart(weeklySpending),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
    );
  }
}
