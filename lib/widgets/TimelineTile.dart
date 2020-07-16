import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runlytics/classes/TimelineActivity.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineTileWidget extends StatelessWidget {
  TimelineTileWidget(this.timelineActivity);

  TimelineActivity timelineActivity;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      topLineStyle: const LineStyle(
        color: Colors.greenAccent,
        width: 6,
      ),
      bottomLineStyle: const LineStyle(
        color: Colors.greenAccent,
        width: 6,
      ),
      alignment: TimelineAlign.manual,
      lineX: 0.3,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: Colors.greenAccent,
        indicatorY: 0.5,
        indicator: Icon(
          Icons.directions_run,
          color: Colors.greenAccent,
        ),
        padding: EdgeInsets.all(8),
      ),
      rightChild: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(9)),
            color: Colors.grey[850].withOpacity(0.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "${timelineActivity.activity_name}",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      timelineActivity.distance >= 1000
                          ? Text(
                              "${(timelineActivity.distance / 1000).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Metrophobic',
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "${timelineActivity.distance.toInt()}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Metrophobic',
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(
                        height: 4,
                      ),
                      timelineActivity.distance >= 1000
                          ? Text(
                              "KM",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "METRES",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(
                        height: 4,
                      ),
                      Icon(
                        FontAwesomeIcons.road,
                        color: Colors.deepOrange[300],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "${timelineActivity.activity_duration_minutes.toString()}:${timelineActivity.activity_duration_seconds.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Metrophobic',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "MINS",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Icon(
                        Icons.timer,
                        color: Colors.deepOrange[300],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "${timelineActivity.calories}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Metrophobic',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "KCAL",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Icon(
                        FontAwesomeIcons.fire,
                        color: Colors.deepOrange[300],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      leftChild: Container(
        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Text(
          "${timelineActivity.timestamp_minutes.toString().padLeft(2, '0')}:${timelineActivity.timestamp_seconds.toString().padLeft(2, '0')}",
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Metrophobic',
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
