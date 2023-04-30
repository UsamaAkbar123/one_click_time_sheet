import 'package:hive/hive.dart';
part 'hive_job_history_model.g.dart';


@HiveType(typeId: 1)
class JobHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<HistoryElement>? historyElement;


  JobHistoryModel({
     required this.id,
    required this.historyElement,
  });
}

@HiveType(typeId: 2)
class HistoryElement{
  @HiveField(0)
  String? type;
  @HiveField(1)
  DateTime? time;
  HistoryElement({
    this.time,
    this.type
  });
}