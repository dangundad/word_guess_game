// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatsModelAdapter extends TypeAdapter<StatsModel> {
  @override
  final typeId = 1;

  @override
  StatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatsModel(
      totalGames: fields[0] == null ? 0 : (fields[0] as num).toInt(),
      totalWins: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      currentStreak: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      maxStreak: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      guessDist: (fields[4] as List?)?.cast<int>(),
      lastPlayedDate: fields[5] == null ? '' : fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StatsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalGames)
      ..writeByte(1)
      ..write(obj.totalWins)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.maxStreak)
      ..writeByte(4)
      ..write(obj.guessDist)
      ..writeByte(5)
      ..write(obj.lastPlayedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
