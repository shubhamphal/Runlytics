// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GoalData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalDataAdapter extends TypeAdapter<GoalData> {
  @override
  final typeId = 3;

  @override
  GoalData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalData(
      fields[2] as String,
      fields[3] as double,
      fields[4] as double,
      fields[6] as int,
      fields[5] as double,
      fields[0] as int,
      (fields[7] as List)?.cast<double>(),
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GoalData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.typeId)
      ..writeByte(1)
      ..write(obj.number_of_attempts)
      ..writeByte(2)
      ..write(obj.runningType)
      ..writeByte(3)
      ..write(obj.challengeTime)
      ..writeByte(4)
      ..write(obj.personalBest)
      ..writeByte(5)
      ..write(obj.distance)
      ..writeByte(6)
      ..write(obj.steps)
      ..writeByte(7)
      ..write(obj.bestStepPace);
  }
}
