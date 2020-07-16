import 'package:runlytics/cache/GoalData.dart';
import 'package:runlytics/classes/RunningGoal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:quiver/async.dart';

import 'RunningScreen.dart';


class RunningMain extends StatefulWidget {
  @override
  _RunningMainState createState() => _RunningMainState();
}

class _RunningMainState extends State<RunningMain> {
  Goal selectedGoal;
  int _start = 15;
  int _current = 15;
  bool _isButtonDisabled;
  int updateTime=10;
  String buttonText="START";
  bool isGoalSelected=false;
  var sub;
  Box _goalDataBox;
  String splitDistance;
  String personalBest;
  String challengeTime;





/** TODO
 * Add ui to edit/add goals
 * */


/**state initialization of goals during first download
 * Goals will be read from cache after first download
 * Aye reader calm down it will use your personal best only not these XD
 * */
  List<Goal> goals=<Goal>[
    Goal('SPRINT 100',15.0,20.0,10,100.0,0),
    Goal('SPRINT 200',35.0,45.0,10,200.0,1),
    Goal('SPRINT 400',70.0,80.0,10,400.0,2),
    Goal('MID RUN 800',210.0,240.0,10,800.0,3),
    Goal('LONG RUN 1K',240.0,275.0,10,1000.0,4),
    Goal('MINI MARATHON 5K',2400.0,2700.0,10,5000.0,5),
    Goal('MARATHON 10K',4200.0,5000.0,10,10000.0,6),
  ];

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() { _current = _start - duration.elapsed.inSeconds; });
    });

    sub.onDone(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  RunningDistanceAndTime(selectedGoal)),
      );

      sub.cancel();
    });
  }

  @override
  void initState() {
    _isButtonDisabled = false;

    _goalDataBox=Hive.box("GoalData");
    if(_goalDataBox.toMap().length==0){
        goals.forEach((Goal goal) {
        GoalData goalData=new GoalData(goal.runningType,goal.challengeTime, goal.personalBest, goal.steps, goal.distance, goal.typeId,List.filled(goal.steps,0),0);
        _goalDataBox.put(goal.typeId,goalData); });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children:<Widget>[Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          SafeArea(child: SizedBox(height: 40,),),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
           Text("GOAL ",
             style:TextStyle(fontSize:20,color: Colors.white,fontFamily: "Metrophobic",),
           ),
          SizedBox(width: 20,),
          Container(
            width: 250,
          color: Colors.black,
          child: new Theme(

            data: Theme.of(context).copyWith(
              canvasColor: Colors.black
            ),
            child:DropdownButton<Goal>(
            hint:  Text("SELECT GOAL",
                   style:TextStyle(
                       fontFamily: "Metrophobic",
                       color: Colors.grey),
            ),
            value: selectedGoal,
            onChanged: (Goal Value) {
              setState(() {
                selectedGoal = Value;
                isGoalSelected=true;
              });
            },
            items: goals.map((Goal goal) {
              return  DropdownMenuItem<Goal>(
                value: goal,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      goal.goalIcon,
                      SizedBox(width: 10,),
                      Text(
                        goal.runningType,
                        style:  TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      )]),

         SizedBox(height: 20,),

          if(selectedGoal!=null)
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
              color:Colors.grey[850].withOpacity(0.5) ,

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.timer,color: Colors.deepOrangeAccent,),
                        SizedBox(height: 20,),
                        Icon(Icons.stars,color: Colors.deepOrangeAccent,),
                        SizedBox(height: 20,),
                        Icon(FontAwesomeIcons.road,color: Colors.deepOrangeAccent,),
                      ],
                    ),
                    Column(children: <Widget>[
                      Text("CHALLENGE TIME", style:  TextStyle(color: Colors.white,fontFamily: "Metrophobic",fontSize: 15),),
                      SizedBox(height: 20,),
                      Text("PERSONAL BEST", style:  TextStyle(color: Colors.white,fontFamily: "Metrophobic",fontSize: 15),),
                      SizedBox(height: 20,),
                      Text("SPLIT DISTANCE", style:  TextStyle(color: Colors.white,fontFamily: "Metrophobic",fontSize: 15),),
                    ],),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Text("${(_goalDataBox.get(selectedGoal.typeId).challengeTime/60).floor().toString().padLeft(2,'0')} : ${(_goalDataBox.get(selectedGoal.typeId).challengeTime%60).toInt().toString().padLeft(2,'0')} min", style:  TextStyle(color: Colors.white,fontFamily: "Metrophobic",fontSize: 15),),
                      SizedBox(height: 20,),
                      Text("${(_goalDataBox.get(selectedGoal.typeId).personalBest/60).floor().toString().padLeft(2,'0')} : ${(_goalDataBox.get(selectedGoal.typeId).personalBest%60).toInt().toString().padLeft(2,'0')} min", style:  TextStyle(color: Colors.white,fontFamily: "Metrophobic",fontSize: 15),),
                      SizedBox(height: 20,),
                      Text("${(_goalDataBox.get(selectedGoal.typeId).distance/selectedGoal.steps).toInt().toString()} m", style:  TextStyle(color: Colors.white,fontFamily: "Metrophobic",fontSize: 15),),
                    ],),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),

          if(isGoalSelected)
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            width : 400,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.greenAccent,
              child: Text('${buttonText}',
                  style:TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    letterSpacing: 2,
                  )),
              onPressed:_isButtonDisabled ? (){
                setState(() {
                  sub.cancel();
                  _current=15;
                  startTimer();

                });

              } : (){
                 buttonText="RESTART";
                _isButtonDisabled=true;
                startTimer();
              },


            ),
          ),
      ]),

        Center(
           child: Container(
            height: 600,
            child:Column(
            children:<Widget>[
              SizedBox(height: 200,),
              Text("$_current",style:TextStyle(
              fontSize: 300.0,
              fontFamily: "Metrophobic",
              color: Colors.grey[800],
              letterSpacing: 2,
            ),),
            ])
        )),



      ])
    );
  }
}
