import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:runlytics/classes/PostRunningAnalytics.dart';
import 'package:runlytics/classes/RunningFlags.dart';
import 'package:runlytics/classes/RunningGoal.dart';
import 'package:runlytics/classes/Speed.dart';
import 'package:runlytics/classes/timerDependencies.dart';
import 'package:runlytics/pages/PostRunningScreen.dart';
import 'package:runlytics/widgets/FlagTimeline.dart';
import 'package:runlytics/widgets/TimerText.dart';
import 'package:slider_button/slider_button.dart';

class RunningDistanceAndTime extends StatefulWidget {
  RunningDistanceAndTime(this.selectedGoal);

  Goal selectedGoal;

  @override
  _RunningDistanceAndTimeState createState() =>
      _RunningDistanceAndTimeState(this.selectedGoal);
}

class _RunningDistanceAndTimeState extends State<RunningDistanceAndTime> {
  _RunningDistanceAndTimeState(this.selectedGoal);


  bool show = true;
  Goal selectedGoal;
  double currentdistanceInMeters = 0;
  double step_distance = 0;
  RunningFlags runningFlags;
  int flag_index = 0;
  int current_index = 0;
  double current_pace = 0;
  double required_pace = 0;
  int minutes_elapsed = 0;
  int seconds_elapsed = 0;
  double time_remaining = 0;
  double distance_remaining = 0;

  double prev_distance = 0;
  bool isOnPace;
  int prev_time;
  DateTime start_timestamp;

  PostRunningResults postRunningResults;

  /*Geolocation Widget*/
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];
  List<SpeedData> speedData = <SpeedData>[];
  final Dependencies dependencies = new Dependencies();
  Timer timer;
  int milliseconds;
  int steps;

  void finish_activity() {
    if (dependencies.stopwatch.isRunning) {
      dependencies.stopwatch.stop();
    }
    _positionStreamSubscription.pause();
    postRunningResults.finish_time_mins = minutes_elapsed % 60;
    postRunningResults.finish_time_seconds = seconds_elapsed % 60;
    postRunningResults.pace = current_pace;
    postRunningResults.positions = _positions;
    postRunningResults.distance = currentdistanceInMeters;
    postRunningResults.start_timestamp = start_timestamp;
    postRunningResults.speedData = speedData;

    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PostRunning(postRunningResults)));
  }

  Future<String> calculateDistance() async {
    if (_positions.length >= 2) {
      prev_distance = currentdistanceInMeters;
      currentdistanceInMeters += await Geolocator().distanceBetween(
          _positions[_positions.length - 2].latitude,
          _positions[_positions.length - 2].longitude,
          _positions[_positions.length - 1].latitude,
          _positions[_positions.length - 1].longitude);
      setState(() {
        flag_index = (currentdistanceInMeters / step_distance).floor();
        if (flag_index > current_index) {
          for (int i = current_index;
              i < (flag_index < (steps) ? flag_index : steps);
              i++) {
            runningFlags.running_flags[i] = true;
          }
          current_index = flag_index;
        }

        current_pace = (((minutes_elapsed % 60) + (seconds_elapsed % 60) / 60) /
                currentdistanceInMeters) *
            1000;

        speedData.add(new SpeedData(
            distance: currentdistanceInMeters, pace: current_pace,timeinseconds: seconds_elapsed.toDouble()));

        if (currentdistanceInMeters >= selectedGoal.distance) {
          finish_activity();
        } else {
          time_remaining = (selectedGoal.challengeTime / 60) -
              ((minutes_elapsed % 60) + (seconds_elapsed % 60) / 60);
          if (time_remaining >= 0) {
            distance_remaining =
                (selectedGoal.distance - currentdistanceInMeters);
            required_pace = (time_remaining / distance_remaining) * 1000;
            if (required_pace < current_pace) {
              isOnPace = false;
            } else {
              isOnPace = true;
            }
          } else {
            required_pace = 0;
            isOnPace = false;
          }
        }
      });
    }
  }

  @override
  void initState() {
    start_timestamp = DateTime.now();
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    runningFlags = new RunningFlags(selectedGoal);
    dependencies.stopwatch.start();
    step_distance = selectedGoal.distance / selectedGoal.steps;
    isOnPace = true;
    required_pace =
        ((selectedGoal.challengeTime / 60) / (selectedGoal.distance)) * 1000;
    steps = selectedGoal.steps;
    postRunningResults = new PostRunningResults(selectedGoal);
    final Stream<Position> positionStream =
        geolocator.getPositionStream(locationOptions);
    _positionStreamSubscription =
        positionStream.listen((Position position) => setState(() {
              _positions.add(position);
              calculateDistance();
            }));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      minutes_elapsed = elapsedTime.minutes;
      seconds_elapsed = elapsedTime.seconds;

      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String kmStr =
        ((currentdistanceInMeters / 1000).toInt()).toString().padLeft(2, '0');
    String mStr = (((currentdistanceInMeters % 1000) / 10).toInt())
        .toString()
        .padLeft(2, '0');
    String distancetext = kmStr + "." + mStr;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Container(
        //color: Colors.grey,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              SafeArea(child: SizedBox(height: 30.0)),
              Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    selectedGoal.goalIcon,

                    //Icon(Icons.flag,color:Colors.deepOrangeAccent),

                    SizedBox(
                      width: 10,
                    ),

                    Text(
                      "${selectedGoal.runningType}",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Metrophobic",
                          fontSize: 20),
                    )
                  ])),
              Container(
                  height: 200,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${distancetext}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Metrophobic",
                              fontSize: 60),
                        ),
                        Text("KM",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Metrophobic")),

                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 40,
                          endIndent: 40,
                        ),

                        //TimerText(dependencies: dependencies),

                        MinutesAndSeconds(
                          dependencies: dependencies,
                        ),

//                        MinutesAndSeconds(
//                          dependencies: dependencies,
//                        ),
                        Text("MIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Metrophobic")),
                      ])),
              SizedBox(height: 40.0),
              RunningTimeline(runningFlags),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 400,
                height: 200,
                margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Stack(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("PACE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Metrophobic"))
                        ]),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            "${current_pace.toStringAsFixed(2).padLeft(2, "0")}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 80,
                                fontFamily: "Metrophobic"))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 100,
                          height: 80,
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[850].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("REQD",
                                          style: TextStyle(
                                              color: isOnPace
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                              fontSize: 20,
                                              fontFamily: "Metrophobic")),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      isOnPace
                                          ? Text(
                                              "${required_pace.toStringAsFixed(2).padLeft(2, "0")}",
                                              style: TextStyle(
                                                  color: Colors.greenAccent,
                                                  fontSize: 20,
                                                  fontFamily: "Metrophobic"))
                                          : Text(
                                              "${required_pace.toStringAsFixed(2).padLeft(2, "0")}",
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 20,
                                                  fontFamily: "Metrophobic")),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                        )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text("MIN/KM",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: "Metrophobic")))
                  ],
                ),
              )
            ]),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SliderButton(
                      width: 300,
                      vibrationFlag: false,
                      backgroundColor: Colors.greenAccent,
                      height: 60,
                      action: () {
                        finish_activity();
                      },
                      label: Text(
                        "SLIDE TO FINISH",
                        style: TextStyle(
                            //0xff4a4a4a
                            color: Color(0xff4a4a4a),
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      icon: Icon(
                        Icons.lock,
                      ))),
            ),
          ],
        ),
      )),
    );
  }
}
