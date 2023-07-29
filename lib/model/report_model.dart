class ReportModel {
  final String jobTitle;
  final String startTime;
  final String endTime;
  final String difference;
  final String considered;
  // final String result;

  ReportModel({
    required this.jobTitle,
    required this.startTime,
    required this.endTime,
    required this.difference,
    required this.considered,
    // required this.result,
  });
}

class FinalReportModel {
  final List<ReportModel> reportModelList;

  FinalReportModel({required this.reportModelList});
}
