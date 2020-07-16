import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runlytics/classes/RunningFlags.dart';


class RunningTimeline extends StatefulWidget {
  RunningTimeline(this.runningFlag);
  RunningFlags runningFlag;
  @override
  _RunningTimelineState createState() => _RunningTimelineState(runningFlag);
}

class _RunningTimelineState extends State<RunningTimeline> {
  _RunningTimelineState(this.runningFlag);
  RunningFlags runningFlag;

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:createTimeline(runningFlag.running_flags),
    );
  }



List<Widget> createTimeline(List<bool> marker_value)
{

  List<Widget> flag_timeline = [];

  if(marker_value.length>0) {
    flag_timeline.add(flag(true));
    for (var i = 0; i < marker_value.length - 1; i++) {
      flag_timeline.add(
          Row(
              children: <Widget>[
              line(marker_value[i]),
              tick(marker_value[i])
            ],
          )
      );
    }

    flag_timeline.add(line(marker_value[marker_value.length - 1]));
    flag_timeline.add(flag(marker_value[marker_value.length - 1]));
  }
   return flag_timeline;
}



 Widget flag(done)
 {
   if(done==true)
     {
       return Icon(Icons.flag,color: Colors.greenAccent,size:40);
     }
   else{
     return Icon(Icons.flag,color: Colors.blueGrey,size:40);
   }
 }


  Widget tick(done)
  {
    if(done==true)
    {
    return Icon(FontAwesomeIcons.checkCircle,color: Colors.greenAccent,size:20);
    }
    else{
      return Icon(FontAwesomeIcons.checkCircle,color: Colors.blueGrey,size:20);
    }
  }


  Widget line(done) {
    if(done==true){
    return Container(
      color: Colors.greenAccent,
      height: 3.0,
      width: 12.0,
    );}
    else{
      return Container(
        color: Colors.blueGrey,
        height: 3.0,
        width: 12.0,
      );
    }
  }



}


