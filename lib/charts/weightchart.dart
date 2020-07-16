import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeightChartState();
}

class WeightChartState extends State<WeightChart> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return
      AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9)),
           color: Colors.grey[850].withOpacity(0.5)
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                    'WEIGHT',
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
                  padding: EdgeInsets.only(left: 8),
                  child: const Text(
                    'measured in kg',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 3.0),
                    child: LineChart(sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
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

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
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
            fontSize: 8,
          ),
          margin: 5,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAY';
              case 7:
                return 'JUN';
              case 12:
                return 'JUL';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 70:
                return  value.toInt().toString();
              case 75:
                return value.toInt().toString();
              case 80:
                return value.toInt().toString();
              case 85:
                return value.toInt().toString();
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
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: 85,
      minY: 65,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {

    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 82),
        FlSpot(3, 79),
        FlSpot(5, 78.2),
        FlSpot(7, 77),
        FlSpot(13, 75),
      ],
      isCurved: true,
      colors: const [
        Colors.deepOrangeAccent,
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData3,
    ];
  }

}