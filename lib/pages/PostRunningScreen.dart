import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:runlytics/cache/GoalData.dart';
import 'package:runlytics/cache/PostRunData.dart';
import 'package:runlytics/charts/postrunningchart.dart';
import 'package:runlytics/classes/PostRunningAnalytics.dart';
import 'package:runlytics/classes/PostRunningChartData.dart';
import 'package:runlytics/classes/Speed.dart';
import 'package:runlytics/machine_learning/LinearRegression.dart';
import 'package:runlytics/widgets/AzureMapRoute.dart';

class PostRunning extends StatefulWidget {
  PostRunning(this.postRunningResults);

  PostRunningResults postRunningResults;

  @override
  _PostRunningState createState() => _PostRunningState(postRunningResults);
}

class _PostRunningState extends State<PostRunning> {
  _PostRunningState(this.postRunningResults);

  PostRunningResults postRunningResults;
  Box _goalDataBox;

  /** TODO
   * Accept weight from Google Fit and calculate active calorie consumption
   * Add username to app user config
   */
  double weight = 75; //default weight
  String username = "Shubham"; //default name

  /**
      calories burned = distance run (kilometres) x weight of runner (kilograms) x 1.036
   */
  double calories_burned = 0;
  double step_distance = 0;
  List<double> average_pace_per_step;
  List<double> x_axis_labels;
  PostRunningChartData postRunningChartData;
  Box _postRunBox;
  bool init_called = false;
  int completion_time = 0;
  LinearRegression linearRegression;
  List<String> botMessage;

  List<String> getBotMessages(List<dynamic> predictions) {
    List<String> botMsg = ["Hi ${username}", "Summary of Today's run"];
    double distance_index;

    for (int i = 0; i < predictions.length; i++) {
      botMsg.add(
          "Estimated time for ${(i + 1) * step_distance}m is ${double.parse(predictions[i].toString()).toStringAsFixed(2)} seconds");
    }
    return botMsg;
  }

  @override
  void initState() {
    calories_burned = (postRunningResults.distance / 1000) * weight * 1.036;
    x_axis_labels = List.filled(postRunningResults.goal.steps, 0);
    average_pace_per_step = List.filled(postRunningResults.goal.steps, 0);
    step_distance =
        postRunningResults.goal.distance / postRunningResults.goal.steps;
    completion_time = (postRunningResults.finish_time_seconds +
        postRunningResults.finish_time_mins * 60);

    for (int i = 0; i < postRunningResults.goal.steps; i++) {
      double total_pace_at_step_i = 0;
      double number_of_entries_in_range = 0;
      x_axis_labels[i] = step_distance * (i + 1);
      for (SpeedData speedDataobj in postRunningResults.speedData) {
        if ((speedDataobj.distance > (i * step_distance)) &&
            (speedDataobj.distance <= ((i + 1) * step_distance))) {
          number_of_entries_in_range += 1;
          total_pace_at_step_i += speedDataobj.pace;
        }
      }
      if (number_of_entries_in_range != 0) {
        average_pace_per_step[i] = double.parse(
            (total_pace_at_step_i / number_of_entries_in_range)
                .toStringAsFixed(2));
      } else {
        average_pace_per_step[i] = 0;
      }
    }
    double maxY = average_pace_per_step.reduce(max).ceilToDouble();
    double minY = average_pace_per_step.reduce(min).floorToDouble();
    double maxX = postRunningResults.goal.distance;

    List<double> trainx = [];
    List<double> trainy = [];
    List<double> predictx = x_axis_labels;

    for (SpeedData speedData in postRunningResults.speedData) {
      trainx.add(speedData.distance);
      trainy.add(speedData.time);
    }

    if (trainx.length >= 4) {
      linearRegression = new LinearRegression(trainx, trainy, predictx);
      botMessage = getBotMessages(linearRegression.get_predictions());
    } else {
      botMessage = [
        'Hi ${username}',
        'Insufficient datapoints for run analysis'
      ];
    }

    _postRunBox = Hive.box("PostRunData");
    String goal_name = postRunningResults.goal.runningType;
    double distance = postRunningResults.distance;
    int duration_in_seconds = postRunningResults.finish_time_seconds +
        60 * postRunningResults.finish_time_mins;
    int calories = calories_burned.toInt();
    int timestamp_hour = postRunningResults.start_timestamp.hour;
    int timestamp_minutes = postRunningResults.start_timestamp.minute;
    DateTime dateTime = new DateTime(
        postRunningResults.start_timestamp.year,
        postRunningResults.start_timestamp.month,
        postRunningResults.start_timestamp.day);
    PostRunData postRunData = new PostRunData(
        goal_name,
        distance,
        duration_in_seconds,
        calories,
        timestamp_hour,
        timestamp_minutes,
        dateTime);
    _postRunBox.add(postRunData);

    _goalDataBox = Hive.box("GoalData");
    GoalData goalData = _goalDataBox.get(postRunningResults.goal.typeId);
    if (goalData.number_of_attempts == 0) {
      goalData.personalBest = completion_time.toDouble();
      goalData.bestStepPace = average_pace_per_step;
    } else {
      if ((completion_time < goalData.personalBest) &&
          (postRunningResults.goal.distance <= postRunningResults.distance)) {
        goalData.bestStepPace = average_pace_per_step;
        goalData.personalBest = completion_time.toDouble();
      }
    }
    goalData.number_of_attempts = goalData.number_of_attempts + 1;
    goalData.save();

    postRunningChartData = new PostRunningChartData(
        xlabels: x_axis_labels,
        ylabels: average_pace_per_step,
        ybestlabels: goalData.bestStepPace,
        ymax: maxY,
        xmax: maxX,
        ymin: minY);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          SafeArea(
            child: SizedBox(
              height: 28,
            ),
          ),
          Container(
            height: 35,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 2),
            decoration: BoxDecoration(
              color: Colors.grey[850].withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  postRunningResults.goal.goalIcon,
                  // Icon(Icons.flag,color: Colors.deepOrangeAccent,size: 25,),
                  //Icon(Icons.flag,color:Colors.deepOrangeAccent),
                  SizedBox(
                    width: 10,
                  ),

                  Text(
                    "${postRunningResults.goal.runningType}",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Metrophobic",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.8),
                    child: AzureMapRoute(postRunningResults.positions),
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              color: Colors.grey[850].withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.fire,
                            color: Colors.deepOrange[300],
                            size: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${calories_burned.toInt()}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: "Metrophobic",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "KCAL",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.clock,
                            color: Colors.deepOrange[300],
                            size: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${postRunningResults.finish_time_mins.toString()}:${postRunningResults.finish_time_seconds.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: "Metrophobic",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "MIN",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.road,
                            color: Colors.deepOrange[300],
                            size: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${(postRunningResults.distance / 1000).toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: "Metrophobic",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "KM",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.running,
                            color: Colors.deepOrange[300],
                            size: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${postRunningResults.pace.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: "Metrophobic",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "MIN/KM",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
//               color: Colors.grey[850].withOpacity(0.5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.grey[850].withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.robot,
                      color: Colors.deepOrange[300],
                    ),
                    SizedBox(width: 20),
                    TyperAnimatedTextKit(
                        isRepeatingAnimation: true,
                        onTap: () {
                          print("Tap Event");
                        },
                        text: botMessage,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                        alignment: AlignmentDirectional
                            .topStart // or Alignment.topLeft
                        ),
                  ],
                ),
              )),
          Container(
              width: 400,
              height: 250,
              margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: PostRunningChart(postRunningChartData)),
        ],
      ),
    ));
  }
}
