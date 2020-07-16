class TimelineActivity{

  String activity_name;
  double distance;
  int calories;
  int timestamp_minutes;
  int timestamp_seconds;
  int activity_duration_minutes;
  int activity_duration_seconds;

  TimelineActivity({String activity_name,double distance,int calories,int activity_duration_minutes,int activity_duration_seconds,int timestamp_minutes,int timestamp_seconds}) {
    this.activity_name=activity_name;
    this.distance=distance;
    this.calories=calories;
    this.activity_duration_minutes=activity_duration_minutes;
    this.activity_duration_seconds=activity_duration_seconds;
    this.timestamp_minutes=timestamp_minutes;
    this.timestamp_seconds=timestamp_seconds;
  }

}