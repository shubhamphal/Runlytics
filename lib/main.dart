import 'package:runlytics/cache/GoalData.dart';
import 'package:runlytics/cache/PostRunData.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:runlytics/machine_learning/LinearRegression.dart';
import 'package:runlytics/widgets/BottomNavigationTab.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(PostRunDataAdapter());
  Hive.registerAdapter(GoalDataAdapter());
  final post_run_data_cache = await Hive.openBox("PostRunData");
  final goal_data_cache = await Hive.openBox("GoalData");
 runApp(MaterialApp(home: TabActivity()));

}

