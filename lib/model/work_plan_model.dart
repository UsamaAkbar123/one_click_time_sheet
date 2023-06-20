
import 'package:hive/hive.dart';
part 'work_plan_model.g.dart';



@HiveType(typeId: 3)
class WorkPlanModel{

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workPlanName;

  @HiveField(2)
  final DateTime startWorkPlanTime;

  @HiveField(3)
  final DateTime endWorkPlanTime;



  WorkPlanModel({
    required this.id,
    required this.workPlanName,
    required this.startWorkPlanTime,
    required this.endWorkPlanTime,
  });

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