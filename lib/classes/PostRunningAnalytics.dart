import 'package:runlytics/classes/RunningGoal.dart';
import 'package:runlytics/classes/Speed.dart';
import 'package:geolocator/geolocator.dart';

class PostRunningResults{

  double distance;
  int finish_time_mins;
  int finish_time_seconds;
  List<Position> positions;
  List<SpeedData> speedData;
  DateTime start_timestamp;

  double pace;
  Goal goal;

  PostRunningResults(Goal rungoal) {
     this.goal=rungoal;
  }

}