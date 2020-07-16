import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Goal {
  int typeId;
  String runningType;
  double challengeTime=0.0;
  double personalBest=0.0;
  double distance;
  int steps;
  Widget goalIcon=Icon(Icons.flag,color: Colors.deepOrangeAccent);
  List<int> stepTime;
  Goal(runningType,challengeTime,personalBest,steps,distance,typeId){
    this.runningType=runningType;
    this.challengeTime=challengeTime;
    this.personalBest=personalBest;
    this.steps=steps;
    this.distance=distance;
    this.typeId=typeId;
  }

}