// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostRunData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostRunDataAdapter extends TypeAdapter<PostRunData> {
  @override
  final typeId = 2;

  @override
  PostRunData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostRunData(
      fields[0] as String,
      fields[1] as double,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
      fields[5] as int,
      fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PostRunData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.goal_name)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
      ..write(obj.duration_in_seconds)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.timestamp_begin_hour)
      ..writeByte(5)
      ..write(obj.timestamp_begin_minute)
      ..writeByte(6)
      ..write(obj.day);
  }
}
