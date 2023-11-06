// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkPlanModelAdapter extends TypeAdapter<WorkPlanModel> {
  @override
  final int typeId = 3;

  @override
  WorkPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkPlanModel(
      id: fields[0] as String,
      workPlanName: fields[1] as String,
      startWorkPlanTime: fields[2] as DateTime,
      endWorkPlanTime: fields[3] as DateTime,
      workPlanDate: fields[4] as DateTime,
      notificationId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkPlanModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workPlanName)
      ..writeByte(2)
      ..write(obj.startWorkPlanTime)
      ..writeByte(3)
      ..write(obj.endWorkPlanTime)
      ..writeByte(4)
      ..write(obj.workPlanDate)
      ..writeByte(5)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
