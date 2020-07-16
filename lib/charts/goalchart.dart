import 'package:runlytics/cache/GoalData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ScatterSpotGoal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScatterSpotGoalState();
}
class _ScatterSpotGoalState extends State {
  int touchedIndex;
  Color greyColor = Colors.grey;
  List<int> selectedSpots = [];
  int lastPanStartOnIndex = -1;
  Box _goalDataBox;
  List<ScatterSpot> scatter_spot_list;

  List<List<double>> coordinates=[[4,4],[2,5],[4,5],[8,6],[5,7],[7,2],[3,2]];

  ScatterTooltipItem getToolTipText(ScatterSpot touchedSpot){
    int goal_index;
     for(int i=0;i<coordinates.length;i++){
        if((coordinates[i][0]==touchedSpot.x)&&(coordinates[i][1]==touchedSpot.y)){
          goal_index=i;
          break;
        }
     }

     GoalData selectedGoal=_goalDataBox.get(goal_index);
    // print(touchedSpot.toString());
    return ScatterTooltipItem("${selectedGoal.runningType} \n ${selectedGoal.number_of_attempts} attempts ",TextStyle(color: Colors.white),10);
  }




  @override
  void initState() {
    _goalDataBox=Hive.box("GoalData");
    scatter_spot_list=[];
    Map<dynamic, dynamic> raw = _goalDataBox.toMap();
    List cached_list = raw.values.toList();

    for(GoalData goalData in cached_list){
      scatter_spot_list.add(ScatterSpot(coordinates[goalData.typeId][0].toDouble(),coordinates[goalData.typeId][1].toDouble(),radius:(goalData.number_of_attempts+5).toDouble(),color:selectedSpots.contains(goalData.typeId) ? Colors.greenAccent : Colors.deepOrangeAccent));
    }


    super.initState();
  }









  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 200,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          color: Colors.grey[850].withOpacity(0.5),
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children:<Widget>[
            Container(
              padding:EdgeInsets.only(right: 8,left: 8),
              child: Text(
                'GOAL',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              padding:EdgeInsets.only(right: 8,left: 8),
              child: const Text(
                'number of attempts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 250,
              width: 200,
              child: ScatterChart(
              ScatterChartData(
               scatterSpots: scatter_spot_list,
//                [
//                  ScatterSpot(
//                    4,
//                    4,
//                    color: selectedSpots.contains(0) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                  ),
//                  ScatterSpot(
//                    2,
//                    5,
//                    color: selectedSpots.contains(1) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                    radius: 12,
//                  ),
//                  ScatterSpot(
//                    4,
//                    5,
//                    color: selectedSpots.contains(2) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                    radius: 8,
//                  ),
//                  ScatterSpot(
//                    8,
//                    6,
//                    color: selectedSpots.contains(3) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                    radius: 20,
//                  ),
//                  ScatterSpot(
//                    5,
//                    7,
//                    color: selectedSpots.contains(4) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                    radius: 14,
//                  ),
//                  ScatterSpot(
//                    7,
//                    2,
//                    color: selectedSpots.contains(5) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                    radius: 18,
//                  ),
//                  ScatterSpot(
//                    3,
//                    2,
//                    color: selectedSpots.contains(6) ? Colors.greenAccent : Colors.deepOrangeAccent,
//                    radius: 36,
//                  ),
//
//                ],
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  checkToShowHorizontalLine: (value) => true,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[800].withOpacity(0.1)),
                  drawVerticalLine: true,
                  checkToShowVerticalLine: (value) => true,
                  getDrawingVerticalLine: (value) => FlLine(color: Colors.grey[800].withOpacity(0.1)),
                ),
                titlesData: FlTitlesData(
                  show: false,
                ),

                showingTooltipIndicators: selectedSpots,
                scatterTouchData: ScatterTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchTooltipData: ScatterTouchTooltipData(
                    getTooltipItems:getToolTipText,
                    tooltipBgColor: Colors.black,
                  ),
                  touchCallback: (ScatterTouchResponse touchResponse) {
                    if (touchResponse.touchInput is FlPanStart) {
                      lastPanStartOnIndex = touchResponse.touchedSpotIndex;
                    } else if (touchResponse.touchInput is FlPanEnd) {
                      final FlPanEnd flPanEnd = touchResponse.touchInput;

                      if (flPanEnd.velocity.pixelsPerSecond <= const Offset(4, 4)) {
                        // Tap happened
                        setState(() {
                          if (selectedSpots.contains(lastPanStartOnIndex)) {
                            selectedSpots.remove(lastPanStartOnIndex);
                          } else {
                            selectedSpots.add(lastPanStartOnIndex);
                          }
                        });
                      }
                    }


                  },
                ),

              ),
          ),
            ),

          ]),
        ),
      ),
    );
  }
}