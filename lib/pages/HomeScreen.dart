import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:runlytics/classes/fitnessactivity.dart';
import 'package:runlytics/pages/PreRunningScreen.dart';
import 'package:runlytics/widgets/AzureMapCurrentPosition.dart';
import 'package:runlytics/widgets/BezierCurve.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fit_kit/fit_kit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /*Google Fit Implementation*/
  String result = '';
  Map<DataType, List<FitData>> results = Map();
  bool permissions;


  List<FitnessActivity> activity=[
    FitnessActivity(name: 'DISTANCE',score: '0',unit: 'KM',icon: Icon(FontAwesomeIcons.road,color: Colors.deepOrangeAccent,)),
    FitnessActivity(name: 'ENERGY',score: '0',unit: 'KCAL',icon:Icon(FontAwesomeIcons.fire,color: Colors.deepOrangeAccent,)),
    FitnessActivity(name: 'STEPS',score: '0',unit:'STEPS',icon: Icon(FontAwesomeIcons.shoePrints,color: Colors.deepOrangeAccent,))
  ];

  Future<void> read() async {
    results.clear();
    try {
      permissions = await FitKit.requestPermissions(DataType.values);
      if (!permissions) {
        result = 'requestPermissions: failed';
      } else {
        for (DataType type in DataType.values) {
          try {

            DateTime time_now=DateTime.now();
            results[type] = await FitKit.read(
              type,
              dateFrom: DateTime(time_now.year,time_now.month,time_now.day),
              dateTo: time_now,
              limit: null,
            );
          } on UnsupportedException catch (e) {
            results[e.dataType] = [];
          }
        }
        result = 'readAll: success';
      }
    } catch (e) {
      result = 'readAll: $e';
    }
    double total_distance_covered=0;
    double total_energy_expended=0;
    double total_steps=0;
    for(FitData fit_data in results[DataType.ENERGY]){
      total_energy_expended+=fit_data.value;
    }
    for(FitData fit_data in results[DataType.DISTANCE]){
      total_distance_covered+=fit_data.value;
    }
    for(FitData fit_data in results[DataType.STEP_COUNT]){
      total_steps+=fit_data.value;
    }


    print(results[DataType.STEP_COUNT]);

    setState(() {

      activity[0].score=(total_distance_covered/1000).toStringAsFixed(2);
      activity[1].score=total_energy_expended.toInt().toString();
      activity[2].score=total_steps.toInt().toString();
    });
  }


  @override
  void initState() {

    read();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child:  SizedBox(height: 2.0),
            ),

            Container(
              height: 300,
              child: Stack(

              children:[


                BezeirCurve(),
                Container(width:30,height:30,margin:EdgeInsets.fromLTRB(2, 2, 2, 2),child: Icon(Icons.menu,color: Colors.white,size:30)),

                Align(
               alignment: Alignment.bottomCenter,
                 child:Container(
                margin: EdgeInsets.fromLTRB(16, 2, 16, 2),
                decoration: BoxDecoration(
                  color:  Colors.grey[850].withOpacity(0.5),

                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: activity.map((quote)=>activityCard(quote)).toList(),

                ),
              )),
              ]),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10)),
                color: Colors.greenAccent,
                child: Text('BEGIN RUNNING',
                    style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      letterSpacing: 2,
                    )),
                onPressed: (){

                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: RunningMain()));
                },
              ),
            ),
            Stack(
            children:[

              Container(
                  margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),),
                  child: Padding(
                    padding: const EdgeInsets.all(1.8),
                    child: AzureMapCurrentPosition(),
                  )
              ),
            ]),

          ],
        ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RunningMain(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }


  Widget activityCard(activity)
  {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: new BoxDecoration(color: Colors.transparent),
      width: 100.0,
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        activity.activity_icon,
         SizedBox(height: 2,),
          Text(
            activity.score,
            style: TextStyle(
              fontSize: 30.0,
              fontFamily:'Metrophobic',
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          Text(
            activity.unit,
            style: TextStyle(
              fontSize: 10.0,

              color: Colors.white,
              letterSpacing: 2,
            ),
          )

        ],
      ),
    );
  }
}


