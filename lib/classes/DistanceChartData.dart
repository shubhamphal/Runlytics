class DistanceData{


  List<String> weekdays = [];
  List<double> distance;



  DistanceData() {
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      weekdays.add(getWeekDay(DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i))
          .weekday));
    }
    distance=  List.filled(7,0,growable:false);

  }

  String getWeekDay(int day_index) {
    String weekDay;
    switch (day_index) {
      case 1:
        weekDay = "Monday";
        break;
      case 2:
        weekDay = 'Tuesday';
        break;
      case 3:
        weekDay = 'Wednesday';
        break;
      case 4:
        weekDay = 'Thursday';
        break;
      case 5:
        weekDay = 'Friday';
        break;
      case 6:
        weekDay = 'Saturday';
        break;
      case 7:
        weekDay = 'Sunday';
        break;
    }

    return weekDay;
  }

}