import 'package:runlytics/cache/GoalData.dart';
import 'package:runlytics/classes/PostRunningChartData.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';


class PostRunningChart extends StatefulWidget {

   PostRunningChart(this.postRunningChartData);
   PostRunningChartData postRunningChartData;
  @override
  State<StatefulWidget> createState() => PostRunningChartState(postRunningChartData);
}



class PostRunningChartState extends State<PostRunningChart> {

  PostRunningChartState(this.postRunningChartData);
  PostRunningChartData postRunningChartData;
  bool isShowingMainData;


  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }


  String get_x_axis_label(double value) {
    if(postRunningChartData.x_labels.contains(value)) {
        return value.toInt().toString();
      }
    return '';
  }

  String get_y_axis_label(double value) {


    return value.toString();
  }


  List<FlSpot> get_chart_best_data(){
    List<FlSpot> chart_data=[];
    chart_data.add(FlSpot(0,postRunningChartData.y_best_labels.first));
    for(int i=0;i<postRunningChartData.x_labels.length;i++) {
      chart_data.add(FlSpot(postRunningChartData.x_labels[i],postRunningChartData.y_best_labels[i]));
    }
    return chart_data;
  }


  List<FlSpot> get_chart_data(){
    List<FlSpot> chart_data=[];
    chart_data.add(FlSpot(0,postRunningChartData.y_labels.first));
    for(int i=0;i<postRunningChartData.x_labels.length;i++) {
        chart_data.add(FlSpot(postRunningChartData.x_labels[i],postRunningChartData.y_labels[i]));
      }
    return chart_data;
  }







  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9)),
          color:  Colors.grey[850].withOpacity(0.5)
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("PACE vs DISTANCE",style: TextStyle(fontSize:15,color: Colors.white,)),
                  ],
                ),

                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.solidCircle,color: Colors.deepOrangeAccent,size: 10,),
                        Text("CURRENT",style: TextStyle(fontSize:10,color: Colors.white,)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.solidCircle,color: Colors.greenAccent,size: 10,),
                        Text("BEST",style: TextStyle(fontSize:10,color: Colors.white,)),
                      ],
                    ),
                  ],

                ),
               SizedBox(height: 5,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 3.0),
                    child: LineChart(sampleData2(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 11,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 5,
         getTitles:(value){return get_x_axis_label(value);}
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {

            int ymax=postRunningChartData.y_max.toInt();
            int ymin=postRunningChartData.y_min.toInt();

            if((value.toInt()>=ymin)&&(value.toInt()<=ymax)){

              return "${value.toInt().toString()}";
            }

            return '';
          },
          margin: 4,
          reservedSize: 15,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 2,
            ),
            left: BorderSide(
              color: Colors.white,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: postRunningChartData.x_max,
      maxY: postRunningChartData.y_max,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: get_chart_data(),
        isCurved: true,
        curveSmoothness: 0,
        colors: [Colors.deepOrangeAccent],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: get_chart_best_data(),
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Colors.greenAccent,
        ],
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}