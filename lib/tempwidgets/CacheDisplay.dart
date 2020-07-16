import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:runlytics/cache/PostRunData.dart';
import 'package:runlytics/classes/TimelineActivity.dart';
import 'package:runlytics/widgets/TimelineTile.dart';

class CacheDataDisplay extends StatefulWidget {
  @override
  _CacheDataDisplayState createState() => _CacheDataDisplayState();
}

class _CacheDataDisplayState extends State<CacheDataDisplay> {
  Box _postRunBox;

  List<TimelineActivity> timeline_activity_list;

  @override
  void initState() {
    _postRunBox = Hive.box("PostRunData");
    timeline_activity_list = [];
    super.initState();
  }

  void remove_record() {
    int lastIndex = _postRunBox.toMap().length - 1;
    if (lastIndex >= 0) _postRunBox.deleteAt(lastIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          FlatButton(
            child: Text("Delete a person"),
            onPressed: remove_record,
            color: Colors.blue,
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box('PostRunData').listenable(),
            builder: (context, Box box, _) {
              if (box.values.isEmpty) {
                return Text('No activity Done yet');
              } else {
                Map<dynamic, dynamic> raw = box.toMap();
                List cached_list = raw.values.toList();

                timeline_activity_list.clear();

                for (PostRunData postRunData in cached_list) {
                  int minutes = (postRunData.duration_in_seconds / 60).floor();
                  int seconds = postRunData.duration_in_seconds % 60;
                  double distance =
                      double.parse(postRunData.distance.toStringAsFixed(2));

                  DateTime postRunDataTime = postRunData.day;
                  DateTime today = DateTime.now();

                  if ((postRunDataTime.year == today.year) &&
                      (postRunDataTime.month == today.month) &&
                      (postRunDataTime.day == today.day)) {
                    timeline_activity_list.add(
                      new TimelineActivity(
                          activity_name: postRunData.goal_name,
                          distance: distance,
                          activity_duration_minutes: minutes,
                          activity_duration_seconds: seconds,
                          calories: postRunData.calories,
                          timestamp_minutes: postRunData.timestamp_begin_hour,
                          timestamp_seconds:
                              postRunData.timestamp_begin_minute),
                    );
                  }
                }

                return Flexible(
                  child: SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          child: Container(
                              child: Column(
                                  children: timeline_activity_list
                                      .map((timelineActivity) =>
                                          TimelineTileWidget(timelineActivity))
                                      .toList())))),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
