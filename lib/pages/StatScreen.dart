import 'package:flutter/material.dart';
import 'package:runlytics/charts/calorieschart.dart';
import 'package:runlytics/charts/distancechart.dart';
import 'package:runlytics/charts/goalchart.dart';
import 'package:runlytics/charts/weightchart.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
            children: <Widget>[
              SafeArea(
                child: SizedBox(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                width: 200,
                child: new WeightChart(),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                width: 200,
                child: new BarChartDistance(),
              ),
            ],
          )),
          SizedBox(
            width: 10,
          ),
          Column(
            children: <Widget>[
              SafeArea(
                child: SizedBox(height: 2.0),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 300,
                width: 200,
                child: new BarChartCalories(),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                width: 200,
                child: new ScatterSpotGoal(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
