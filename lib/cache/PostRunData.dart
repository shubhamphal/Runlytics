import 'package:hive/hive.dart';

part 'PostRunData.g.dart';

@HiveType(typeId: 2)
class PostRunData{

  /*running type*/
  @HiveField(0)
  String goal_name;

  @HiveField(1)
  double distance;

  @HiveField(2)
  int duration_in_seconds;

  @HiveField(3)
  int calories;

  @HiveField(4)
  int timestamp_begin_hour;

  @HiveField(5)
  int timestamp_begin_minute;

  @HiveField(6)
  DateTime day;

  PostRunData(this.goal_name, this.distance, this.duration_in_seconds,this.calories,this.timestamp_begin_hour,this.timestamp_begin_minute,this.day);

}