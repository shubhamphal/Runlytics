import 'package:flutter/material.dart';
import 'package:runlytics/pages/ActivityScreen.dart';
import 'package:runlytics/pages/HomeScreen.dart';
import 'package:runlytics/pages/StatScreen.dart';

class TabActivity extends StatefulWidget {
  @override
  _TabActivityState createState() => _TabActivityState();
}

class _TabActivityState extends State<TabActivity> {
  int _currentIndex = 0;
  List<Widget> _children;

  @override
  void initState() {
    _children = [Home(), FitnessTimeline(), Analytics()];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: IndexedStack(index: _currentIndex, children: _children),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.black,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.greenAccent,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(color: Colors.deepOrange[300]))),
          child: new BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_run),
                title: Text('Activity'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                title: Text('Stats'),
              ),
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
