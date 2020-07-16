import 'package:runlytics/classes/RunningGoal.dart';


class RunningFlags {
  List<bool> running_flags;
  RunningFlags(Goal runningGoal)
  {
    running_flags=List.filled(runningGoal.steps, false,growable:false);
  }
}