import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:runlytics/cache/PostRunData.dart';
import 'package:runlytics/classes/TimelineActivity.dart';
import 'package:runlytics/widgets/TimelineTile.dart';

class FitnessTimeline extends StatefulWidget {
  @override
  _FitnessTimelineState createState() => _FitnessTimelineState();
}

class _FitnessTimelineState extends State<FitnessTimeline> {
  DateTime selectedDate = DateTime.now();
  Box _postRunBox;
  List<TimelineActivity> timeline_activity_list = [];
  List<TimelineTileWidget> timelineTileWidgetList = [];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            //OK/Cancel button text color
            primaryColorDark: Colors.black,
            primaryColor: Colors.white,
            //Head background
            accentColor: Colors.white,
            //selection color
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              //surface: Colors.pink,
              onSurface: Colors.greenAccent,
            ),
            textSelectionColor: Colors.transparent,
            dialogBackgroundColor:
                Colors.grey[900].withOpacity(1), //Background color
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        timeline_activity_list.clear();
      });
  }

  String getWeekDay(int day_index) {
    String weekDay;
    switch (day_index) {
      case 1:
        weekDay = "MONDAY";
        break;
      case 2:
        weekDay = 'TUESDAY';
        break;
      case 3:
        weekDay = 'WEDNESDAY';
        break;
      case 4:
        weekDay = 'THURSDAY';
        break;
      case 5:
        weekDay = 'FRIDAY';
        break;
      case 6:
        weekDay = 'SATURDAY';
        break;
      case 7:
        weekDay = 'SUNDAY';
        break;
    }

    return weekDay;
  }

  String getMonth(int day_index) {
    String weekDay;
    switch (day_index) {
      case 1:
        weekDay = "JANUARY";
        break;
      case 2:
        weekDay = 'FEBRUARY';
        break;
      case 3:
        weekDay = 'MARCH';
        break;
      case 4:
        weekDay = 'APRIL';
        break;
      case 5:
        weekDay = 'MAY';
        break;
      case 6:
        weekDay = 'JUNE';
        break;
      case 7:
        weekDay = 'JULY';
        break;
      case 8:
        weekDay = 'AUGUST';
        break;
      case 9:
        weekDay = 'SEPTEMBER';
        break;
      case 10:
        weekDay = 'OCTOBER';
        break;
      case 11:
        weekDay = 'NOVEMBER';
        break;
      case 12:
        weekDay = 'DECEMBER';
        break;
    }

    return weekDay;
  }

  @override
  void initState() {
    _postRunBox = Hive.box("PostRunData");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SafeArea(
            child: SizedBox(
          height: 20.0,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${getWeekDay(selectedDate.weekday)}, ${getMonth(selectedDate.month)} ${selectedDate.day}",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            Flex(direction: Axis.vertical, children: <Widget>[
              IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(FontAwesomeIcons.calendarAlt,
                    color: Colors.deepOrange[300]),
              ),
            ]),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
          valueListenable: Hive.box('PostRunData').listenable(),
          builder: (context, Box box, _) {
            if (box.values.isEmpty) {
              return Text(
                "No records to display",
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              );
            } else {
              Map<dynamic, dynamic> raw = box.toMap();
              List cached_list = raw.values.toList();

              timeline_activity_list.clear();
              timelineTileWidgetList.clear();

              for (PostRunData postRunData in cached_list.reversed) {
                print(
                    "PostRunData Outer loop ${postRunData.goal_name} ${postRunData.timestamp_begin_hour} ${postRunData.timestamp_begin_minute}");

                int minutes = (postRunData.duration_in_seconds / 60).floor();
                int seconds = postRunData.duration_in_seconds % 60;
                double distance =
                    double.parse(postRunData.distance.toStringAsFixed(2));
                DateTime postRunDataTime = postRunData.day;

                print(selectedDate);

                if ((postRunDataTime.year == selectedDate.year) &&
                    (postRunDataTime.month == selectedDate.month) &&
                    (postRunDataTime.day == selectedDate.day)) {
                  print(
                      "PostRunData Inner loop ${postRunData.goal_name} ${postRunData.timestamp_begin_hour} ${postRunData.timestamp_begin_minute}");

                  timeline_activity_list.add(
                    new TimelineActivity(
                        activity_name: postRunData.goal_name,
                        distance: distance,
                        activity_duration_minutes: minutes,
                        activity_duration_seconds: seconds,
                        calories: postRunData.calories,
                        timestamp_minutes: postRunData.timestamp_begin_hour,
                        timestamp_seconds: postRunData.timestamp_begin_minute),
                  );
                }
              }

              for (TimelineActivity timelineactivity
                  in timeline_activity_list) {
                timelineTileWidgetList
                    .add(new TimelineTileWidget(timelineactivity));
              }

              return Flexible(
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
                        child: Container(
                            child: Column(children: timelineTileWidgetList)))),
              );
            }
          },
        )
      ],
    );
  }
}
