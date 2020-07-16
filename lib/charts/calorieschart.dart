import 'dart:async';
import 'dart:math';
import 'package:fit_kit/fit_kit.dart';
import 'package:runlytics/classes/CaloriesChartData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartCalories extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => BarChartCaloriesState();
}

class BarChartCaloriesState extends State<BarChartCalories> {
  final Color barBackgroundColor = Colors.blueGrey.withOpacity(0.5);
  final Duration animDuration = const Duration(milliseconds: 250);

  String result = '';
  bool permissions;
  List<FitData> daywise_result;

  CaloriesData caloriesData=new CaloriesData();
  int touchedIndex;
  bool isPlaying = false;


  Future<void> read() async {

    try {
      permissions = await FitKit.requestPermissions(DataType.values);
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {
        for (int i = 6; i >= 0; i--) {
          try {
            DateTime time_now = DateTime.now().subtract(Duration(days: i));

              daywise_result = await FitKit.read(DataType.ENERGY,
              dateFrom: DateTime(time_now.year, time_now.month, time_now.day),
              dateTo:i==0?time_now:DateTime(time_now.year, time_now.month, time_now.day,23,59),
              limit: null,
            );
              double calorie_sum=0;
              daywise_result.forEach((FitData fitData) { calorie_sum+=fitData.value;});
              caloriesData.calories[6-i]=calorie_sum.floor().toDouble();

              daywise_result.clear();

          } on UnsupportedException catch (e) {
            result="unsupported exception";
          }
        }

       setState(() {

       });


          result = 'readAll: success';
        }
      } catch (e) {
      result = 'readAll: $e';
    }
  }


  @override
  void initState() {
    read();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        color: Colors.grey[850].withOpacity(0.5),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'CALORIES',
                    style: TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'measured in kcal',
                    style: TextStyle(
                        color: Colors.white, fontSize: 10,),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.deepOrangeAccent,
        double width = 11,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.deepOrange : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 5000,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    return makeGroupData(i, caloriesData.calories[i], isTouched: i == touchedIndex);
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;

              weekDay=caloriesData.weekdays[group.x.toInt()];
              return BarTooltipItem(
                   (rod.y - 1).toString(), TextStyle(color: Colors.white));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          margin: 8,
          getTitles: (double value) {
            return caloriesData.weekdays[value.toInt()].substring(0,2);
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }



  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}