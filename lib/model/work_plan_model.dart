import 'package:hive/hive.dart';
part 'work_plan_model.g.dart';

@HiveType(typeId: 3)
class WorkPlanModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workPlanName;

  @HiveField(2)
  final DateTime startWorkPlanTime;

  @HiveField(3)
  final DateTime endWorkPlanTime;

  @HiveField(4)
  final DateTime workPlanDate;

  @HiveField(5)
  int ? notificationIdForStartJob;

  @HiveField(6)
  int ? notificationIdForEndJob;

  WorkPlanModel({
    required this.id,
    required this.workPlanName,
    required this.startWorkPlanTime,
    required this.endWorkPlanTime,
    required this.workPlanDate,
    this.notificationIdForStartJob,
    this.notificationIdForEndJob,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workPlanName': workPlanName,
      'startWorkPlanTime': startWorkPlanTime.toIso8601String(),
      'endWorkPlanTime': endWorkPlanTime.toIso8601String(),
      'workPlanDate': workPlanDate.toIso8601String(),
      'notificationIdForStartJob': notificationIdForStartJob,
      'notificationIdForEndJob': notificationIdForEndJob,
    };
  }

  static WorkPlanModel fromFirebaseJson(Map<String, dynamic> json) {
    return WorkPlanModel(
      id: json['id'],
      workPlanName: json['workPlanName'],
      startWorkPlanTime: DateTime.parse(json['startWorkPlanTime']),
      endWorkPlanTime: DateTime.parse(json['endWorkPlanTime']),
      workPlanDate: DateTime.parse(json['workPlanDate']),
      notificationIdForStartJob: json['notificationIdForStartJob'],
      notificationIdForEndJob: json['notificationIdForEndJob'],
    );
  }
  // factory WorkPlanModel.fromJson(Map<String, dynamic> json) {
  //   return WorkPlanModel(
  //     id: json['id'] as String,
  //     workPlanName: json['workPlanName'] as String,
  //     startWorkPlanTime: json['startWorkPlanTime'] as DateTime,
  //     endWorkPlanTime: json['endWorkPlanTime'] as DateTime,
  //   );
  // }

  // factory WorkPlanModel.fromJson(Map<String, dynamic> json) {
  //   return WorkPlanModel(
  //     id: json['id'] as String,
  //     historyElement: json['historyElement'] as List<HistoryElement>,
  //   );
  // }
}
