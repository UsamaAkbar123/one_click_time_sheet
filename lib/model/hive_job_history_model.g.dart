// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_job_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobHistoryModelAdapter extends TypeAdapter<JobHistoryModel> {
  @override
  final int typeId = 1;

  @override
  JobHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobHistoryModel(
      id: fields[0] as String,
      historyElement: (fields[1] as List?)?.cast<HistoryElement>(),
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JobHistoryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.historyElement)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoryElementAdapter extends TypeAdapter<HistoryElement> {
  @override
  final int typeId = 2;

  @override
  HistoryElement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryElement(
      time: fields[1] as DateTime?,
      type: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryElement obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryElementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
