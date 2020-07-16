
import 'package:flutter/material.dart';
class  FitnessActivity{

  String name;
  String score;
  String unit;
  Icon activity_icon;


  FitnessActivity({String name,String score,String unit,Icon icon}) {
    this.name=name;
    this.score=score;
    this.unit=unit;
    this.activity_icon=icon;
  }
}

