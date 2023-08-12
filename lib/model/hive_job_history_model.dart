import 'package:hive/hive.dart';
part 'hive_job_history_model.g.dart';

@HiveType(typeId: 1)
class JobHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  List<HistoryElement>? historyElement;

  @HiveField(2)
  final DateTime timestamp;

  JobHistoryModel({
    required this.id,
    required this.historyElement,
    required this.timestamp,
  });

  factory JobHistoryModel.fromJson(Map<String, dynamic> json) {
    return JobHistoryModel(
      id: json['id'] as String,
      historyElement: json['historyElement'] as List<HistoryElement>,
      timestamp: json['timestamp'] as DateTime,
    );
  }
}

@HiveType(typeId: 2)
class HistoryElement {
  @HiveField(0)
  String? type;
  @HiveField(1)
  DateTime? time;
  @HiveField(2)
  String? elementId;
  HistoryElement({this.time, this.type, this.elementId});
}
