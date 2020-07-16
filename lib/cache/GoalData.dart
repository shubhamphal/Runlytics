import 'package:hive/hive.dart';

part 'GoalData.g.dart';

@HiveType(typeId: 3)
class GoalData extends HiveObject{

  @HiveField(0)
  int typeId;

  @HiveField(1)
  int number_of_attempts;

  @HiveField(2)
  String runningType;

  @HiveField(3)
  double challengeTime;

  @HiveField(4)
  double personalBest;

  @HiveField(5)
  double distance;

  @HiveField(6)
  int steps;

  @HiveField(7)
  List<double> bestStepPace;

  GoalData(this.runningType,this.challengeTime,this.personalBest,this.steps,this.distance,this.typeId,this.bestStepPace,this.number_of_attempts);


}