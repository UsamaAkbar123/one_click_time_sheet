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

  @HiveField(3)
  final String uuid;

  JobHistoryModel({
    required this.id,
    required this.historyElement,
    required this.timestamp,
    required this.uuid,
  });

  factory JobHistoryModel.fromJson(Map<String, dynamic> json) {
    return JobHistoryModel(
      id: json['id'] as String,
      historyElement: json['historyElement'] as List<HistoryElement>,
      uuid: json['uuid'] as String,
      timestamp: json['timestamp'] as DateTime,
    );
  }
  factory JobHistoryModel.firebaseJson(Map<String, dynamic> json) {
    var historyElementList = json['historyElement'] as List?;
    List<HistoryElement>? historyElements;
    if (historyElementList != null) {
      historyElements = historyElementList.map((e) => HistoryElement.fromJson(e as Map<String, dynamic>)).toList();
    }

    return JobHistoryModel(
      id: json['id'] as String,
      uuid: json['uuid'] as String,
      historyElement: historyElements,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Add this to your JobHistoryModel class
  Map<String, dynamic> toJson() => {
    'id': id,
    'uuid': uuid,
    'historyElement': historyElement?.map((e) => e.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
  };
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

  factory HistoryElement.fromJson(Map<String, dynamic> json) {
    return HistoryElement(
      type: json['type'] as String?,
      time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
      elementId: json['elementId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'time': time?.toIso8601String(),
    'elementId': elementId,
  };
}
