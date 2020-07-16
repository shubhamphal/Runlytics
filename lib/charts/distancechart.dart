import 'package:runlytics/classes/DistanceChartData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fit_kit/fit_kit.dart';

class BarChartDistance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartDistanceState();
}

class BarChartDistanceState extends State<BarChartDistance> {
  final Color leftBarColor = Colors.deepOrangeAccent;
  final double width = 8;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex;

  //initial default value
  double y_max=5000;

  String result = '';
  bool permissions;
  List<FitData> daywise_result;

  DistanceData distanceData=new DistanceData();

  Future<void> read() async {
    try {
      permissions = await FitKit.requestPermissions(DataType.values);
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {

        double max_distance=0;
        for (int i = 6; i >= 0; i--) {
          try {
            DateTime time_now = DateTime.now().subtract(Duration(days: i));

            daywise_result = await FitKit.read(DataType.DISTANCE,
              dateFrom: DateTime(time_now.year, time_now.month, time_now.day),
              dateTo:i==0?time_now:DateTime(time_now.year, time_now.month, time_now.day,23,59),
              limit: null,
            );
            double distance_sum=0;
            daywise_result.forEach((FitData fitData) { distance_sum+=fitData.value;});
            distanceData.distance[6-i]=distance_sum.floor().toDouble();

            if(distance_sum>max_distance){
              max_distance=distance_sum;
            }
            daywise_result.clear();

          } on UnsupportedException catch (e) {
            result="unsupported exception";
          }
        }

        y_max=max_distance;

        rawBarGroups.clear();
        for(int i=0;i<=6;i++) {
          rawBarGroups.add(makeGroupData(i,distanceData.distance[i]));
        }
        showingBarGroups = rawBarGroups;

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


    rawBarGroups=[];
    for(int i=0;i<=6;i++) {
      rawBarGroups.add(makeGroupData(i,distanceData.distance[i]));
      }

    showingBarGroups = rawBarGroups;
  }






  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        color: Colors.grey[850].withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text(
                  'DISTANCE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'measured in km',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                ],
              ),
              const SizedBox(
                height: 19,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: BarChart(
                    BarChartData(
                      maxY:y_max,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor:  Colors.white,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex = response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is FlLongPressEnd ||
                                  response.touchInput is FlPanEnd) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                  in showingBarGroups[touchedGroupIndex].barRods) {
                                    sum += rod.y;
                                  }
                                  final avg =
                                      sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex].copyWith(
                                        barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                          return rod.copyWith(y: avg);
                                        }).toList(),
                                      );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color:  Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                          margin: 10,
                          getTitles: (double value) {
                            return distanceData.weekdays[value.toInt()].substring(0,2);
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color:  Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                          margin: 16,
                          reservedSize: 7,
                          getTitles: (value) {

                            if (value == 1000) {
                              return '1K';
                            } else if (value == 2000) {
                              return '2K';
                            } else if (value == 3000) {
                              return '3K';
                            }
                            else if (value == 4000) {
                              return '4K';
                            } else if (value == 5000) {
                              return '5K';
                            }
                            else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
//      BarChartRodData(
//        y: y2,
//        color: rightBarColor,
//        width: width,
//      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 2.5;
    const double space = 2.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 5,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 14,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 21,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 14,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 5,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}