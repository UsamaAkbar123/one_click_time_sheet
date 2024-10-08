// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/model/report_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/reports/constant/common_functions.dart';
import 'package:one_click_time_sheet/view/reports/pdf_services/pdf_services.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/custom_save_pdf_send_email_button.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/header_date_of_table.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/sum_block_widget.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/table_meta_data_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final Box box = Hive.box('jobHistoryBox');
  String selectedMonth = '';
  late String selectedMonthAndYear;
  DateTime currentDate = DateTime.now();
  int currentMonth = DateTime.now().month;
  PreferenceManager preferenceManager = PreferenceManager();

  List<FinalReportModel> listOfFinalReportForPdf = [];

  List<ReportModel> reportModelListForPdf = [];
  List<ReportSumModel> reportSumList = [];
  bool isJobListEmpty = false;
  Duration totalJobTime = const Duration();

  @override
  void initState() {
    selectedMonth = selectMonth(currentMonth);
    selectedMonthAndYear = '$selectedMonth ${currentDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.reportsScreenTitle ?? '',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 20.h),
                Container(
                  height: 40.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: blackColor,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          listOfFinalReportForPdf = [];
                          reportModelListForPdf = [];
                          reportSumList = [];
                          setState(() {
                            if (currentMonth != 1) {
                              currentMonth--;
                              selectedMonth = selectMonth(currentMonth);
                              selectedMonthAndYear =
                                  '$selectedMonth ${currentDate.year}';
                            } else if (currentMonth == 1) {
                              currentMonth = 12;
                              selectedMonth = selectMonth(currentMonth);
                              currentDate =
                                  DateTime(currentDate.year - 1, currentMonth);
                              selectedMonthAndYear =
                                  '$selectedMonth ${currentDate.year}';
                            }
                          });
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: blackColor,
                          size: 18.h,
                        ),
                      ),
                      Text(
                        selectedMonthAndYear,
                        style: CustomTextStyle.kBodyText1.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          listOfFinalReportForPdf = [];
                          reportModelListForPdf = [];
                          reportSumList = [];
                          setState(() {
                            if (currentMonth != 12) {
                              currentMonth++;
                              selectedMonth = selectMonth(currentMonth);
                              selectedMonthAndYear =
                                  '$selectedMonth ${currentDate.year}';
                            } else if (currentMonth == 12) {
                              currentMonth = 1;
                              selectedMonth = selectMonth(currentMonth);
                              currentDate =
                                  DateTime(currentDate.year + 1, currentMonth);
                              selectedMonthAndYear =
                                  '$selectedMonth ${currentDate.year}';
                            }
                          });
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: blackColor,
                          size: 18.h,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                box.isNotEmpty
                    ? ValueListenableBuilder(
                        valueListenable: box.listenable(),
                        builder: (context, Box box, widget) {
                          // print('box length: ${box.length}');
                          final keys = box.keys.toList();
                          keys.sort((a, b) {
                            return DateFormat('EEEE, dd, M, yyyy')
                                .parse(b)
                                .compareTo(
                                    DateFormat('EEEE, dd, M, yyyy').parse(a));
                          });
                          return ListView.builder(
                            // itemCount: box.length,
                            itemCount: keys.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              final key = keys[i];
                              List<JobHistoryModel> jobList =
                                  box.get(key).cast<JobHistoryModel>();
                              // String id = box.keyAt(i);
                              String id = '';
                              String originalId = key;

                              DateTime dateTime =
                                  DateFormat('EEEE, dd, M, yyyy').parse(key);
                              id = DateFormat(preferenceManager.getDateFormat)
                                  .format(dateTime);

                              jobList = jobList.where((job) {
                                return job.timestamp.month == currentMonth &&
                                    job.timestamp.year == currentDate.year;
                              }).toList();

                              jobList.sort(
                                (a, b) => b.timestamp.compareTo(a.timestamp),
                              );

                              // print(jobList.length);

                              return jobList.isEmpty
                                  ? const Center(
                                      child:
                                          // i == 0
                                          //     ? const Text(
                                          //         'No Data Found for this month')
                                          //     :
                                          SizedBox(),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 13.h),
                                        Text(
                                          id,
                                          style: CustomTextStyle.kBodyText1
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        ListView.builder(
                                          itemCount: jobList.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemBuilder: (context, j) {
                                            String uuid = jobList[j].uuid;
                                            int totalHoursForFinalSumResult = 0;
                                            int totalMinutesForFinalSumResult =
                                                0;
                                            List<HistoryElement>?
                                                historyElementList =
                                                jobList[j].historyElement ?? [];

                                            historyElementList.sort(
                                              (a, b) => a.time!.compareTo(
                                                  b.time ?? DateTime.now()),
                                            );
                                            return Column(
                                              children: [
                                                const HeaderDataOfTable(),
                                                ListView.builder(
                                                  itemCount: historyElementList
                                                          .length -
                                                      1,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, k) {
                                                    String startTime = '';
                                                    String endTime = '';

                                                    int hours = 0;
                                                    int minutes = 0;

                                                    if (k == 0) {
                                                      startTime =
                                                          getStartEndTimeOfReport(
                                                        preferenceManager,
                                                        historyElementList
                                                            .first,
                                                      );

                                                      endTime =
                                                          getStartEndTimeOfReport(
                                                        preferenceManager,
                                                        historyElementList.last,
                                                      );
                                                      DateTime startDateTime =
                                                          getStartEndDateTime(
                                                        historyElementList
                                                            .first,
                                                      );

                                                      DateTime endDateTime =
                                                          getStartEndDateTime(
                                                        historyElementList.last,
                                                      );

                                                      Duration difference =
                                                          endDateTime.difference(
                                                              startDateTime);

                                                      totalJobTime = endDateTime
                                                          .difference(
                                                              startDateTime);
                                                      hours =
                                                          difference.inHours;
                                                      minutes = difference
                                                          .inMinutes
                                                          .remainder(60);

                                                      totalHoursForFinalSumResult =
                                                          totalHoursForFinalSumResult +
                                                              hours;

                                                      totalMinutesForFinalSumResult =
                                                          totalMinutesForFinalSumResult +
                                                              minutes;
                                                    } else {
                                                      if (k + 1 <
                                                          historyElementList
                                                              .length) {
                                                        startTime =
                                                            getStartEndTimeOfReport(
                                                          preferenceManager,
                                                          historyElementList[k],
                                                        );
                                                        endTime =
                                                            getStartEndTimeOfReport(
                                                          preferenceManager,
                                                          historyElementList[
                                                              k + 1],
                                                        );
                                                        DateTime startDateTime =
                                                            getStartEndDateTime(
                                                          historyElementList[k],
                                                        );
                                                        DateTime endDateTime =
                                                            getStartEndDateTime(
                                                                historyElementList[
                                                                    k + 1]);
                                                        Duration difference =
                                                            endDateTime.difference(
                                                                startDateTime);

                                                        hours =
                                                            difference.inHours;
                                                        minutes = difference
                                                            .inMinutes
                                                            .remainder(60);

                                                        if (historyElementList[
                                                                        k]
                                                                    .type ==
                                                                'Unpaid Break' ||
                                                            historyElementList[
                                                                        k]
                                                                    .type ==
                                                                'unpaid break') {
                                                          // Define break duration
                                                          Duration breakTime =
                                                              Duration(
                                                            hours: hours,
                                                            minutes: minutes,
                                                          );
                                                          Duration netJobTime =
                                                              totalJobTime -
                                                                  breakTime;

                                                          Duration
                                                              netDeductionTime =
                                                              totalJobTime -
                                                                  netJobTime;

                                                          totalJobTime =
                                                              totalJobTime -
                                                                  netDeductionTime;

                                                          // print(
                                                          //     "$id ===> hours ${netJobTime.inHours} ==> minutes ${netJobTime.inMinutes.remainder(60)}");

                                                          // print(
                                                          //     "$id ===> hours ${totalJobTime.inHours} ==> minutes ${totalJobTime.inMinutes.remainder(60)}");

                                                          int hoursTem =
                                                              netJobTime
                                                                  .inHours;
                                                          int minutesTem =
                                                              netJobTime
                                                                  .inMinutes
                                                                  .remainder(
                                                                      60);

                                                          totalHoursForFinalSumResult =
                                                              hoursTem;

                                                          totalMinutesForFinalSumResult =
                                                              minutesTem;
                                                          // totalHoursForFinalSumResult =
                                                          //     totalHoursForFinalSumResult -
                                                          //         hoursTem;

                                                          // totalMinutesForFinalSumResult =
                                                          //     totalMinutesForFinalSumResult -
                                                          //         minutesTem;
                                                        }
                                                      }
                                                    }

                                                    if (k == 0) {
                                                      reportModelListForPdf.add(
                                                        ReportModel(
                                                          jobTitle: 'Work',
                                                          startTime: startTime,
                                                          endTime: endTime,
                                                          difference:
                                                              '$hours:${minutes.toString().padLeft(2, '0')}',
                                                          considered:
                                                              '$hours:${minutes.toString().padLeft(2, '0')}',
                                                          // result:
                                                          //     '$totalHoursForFinalSumResult:${totalMinutesForFinalSumResult.toString().padLeft(2, '0')}',
                                                        ),
                                                      );
                                                    } else {
                                                      if (historyElementList[k]
                                                              .type !=
                                                          'Start Job') {
                                                        reportModelListForPdf
                                                            .add(
                                                          ReportModel(
                                                            jobTitle:
                                                                historyElementList[
                                                                            k]
                                                                        .type ??
                                                                    '',
                                                            startTime:
                                                                startTime,
                                                            endTime: endTime,
                                                            difference:
                                                                '$hours:${minutes.toString().padLeft(2, '0')}',
                                                            considered: historyElementList[
                                                                            k]
                                                                        .type ==
                                                                    'Unpaid Break'
                                                                ? '-$hours:${minutes.toString().padLeft(2, '0')}'
                                                                : historyElementList[k]
                                                                            .type ==
                                                                        'Paid Break'
                                                                    ? '0:00'
                                                                    : '$hours:${minutes.toString().padLeft(2, '0')}',
                                                          ),
                                                        );
                                                      }
                                                    }

                                                    if (k + 1 ==
                                                        jobList[j]
                                                                .historyElement!
                                                                .length -
                                                            1) {
                                                      listOfFinalReportForPdf
                                                          .add(FinalReportModel(
                                                        id: id,
                                                        reportModelList:
                                                            reportModelListForPdf,
                                                      ));
                                                      reportSumList.add(
                                                        ReportSumModel(
                                                          sum:
                                                              '$totalHoursForFinalSumResult:${totalMinutesForFinalSumResult.toString().padLeft(2, '0')}',
                                                        ),
                                                      );
                                                      reportModelListForPdf =
                                                          [];
                                                    }

                                                    return Column(
                                                      children: [
                                                        if (k == 0)
                                                          TableMetaDataWidget(
                                                            jobType: 'Work',
                                                            startTime:
                                                                startTime,
                                                            endTime: endTime,
                                                            difference:
                                                                '$hours:${minutes.toString().padLeft(2, '0')}',
                                                            consider:
                                                                '$hours:${minutes.toString().padLeft(2, '0')}',
                                                            editDeleteHistoryElement:
                                                                historyElementList,
                                                            indexKey:
                                                                originalId,
                                                            iIndex: i,
                                                            uuid: uuid,
                                                          ),
                                                        historyElementList[k]
                                                                    .type ==
                                                                'Start Job'
                                                            ? const SizedBox()
                                                            : TableMetaDataWidget(
                                                                jobType: historyElementList[
                                                                            k]
                                                                        .type ??
                                                                    '',
                                                                startTime:
                                                                    startTime,
                                                                endTime:
                                                                    endTime,
                                                                difference:
                                                                    '$hours:${minutes.toString().padLeft(2, '0')}',
                                                                consider: historyElementList[k]
                                                                            .type ==
                                                                        'Unpaid Break'
                                                                    ? '-$hours:${minutes.toString().padLeft(2, '0')}'
                                                                    : historyElementList[k].type ==
                                                                            'Paid Break'
                                                                        ? '0:00'
                                                                        : '$hours:${minutes.toString().padLeft(2, '0')}',
                                                                editDeleteHistoryElement:
                                                                    historyElementList,
                                                                indexKey:
                                                                    originalId,
                                                                iIndex: i,
                                                                uuid: uuid,
                                                              ),
                                                        k + 1 ==
                                                                jobList[j]
                                                                        .historyElement!
                                                                        .length -
                                                                    1
                                                            ? sumBlock(
                                                                totalHours:
                                                                    totalHoursForFinalSumResult,
                                                                totalMinutes:
                                                                    totalMinutesForFinalSumResult,
                                                                listId:
                                                                    originalId,
                                                                historyElement:
                                                                    historyElementList,
                                                                context:
                                                                    context,
                                                                iIndex: i,
                                                                jIndex: j,
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    );
                                                  },
                                                ),
                                                SizedBox(height: 15.h),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    );
                            },
                          );
                        })
                    : const Center(
                        child: Text("No history found"),
                      ),
                SizedBox(height: 45.h),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomSavePdfSendEmailButton(
                      buttonText: AppLocalizations.of(context)
                              ?.reportsScreenSaveToPdf ??
                          '',
                      onTab: () async {
                        // print(listOfFinalReportForPdf.length);
                        // for (int i = 0;
                        //     i < listOfFinalReportForPdf.length;
                        //     i++) {
                        //   // print(listOfFinalReportForPdf[i].reportModelList);
                        // }
                        final data = await PdfServices().createMonthlyReport(
                          monthYearReportName: "$selectedMonthAndYear Report",
                          reportList: listOfFinalReportForPdf,
                          sumList: reportSumList,
                        );
                        PdfServices()
                            .savePdfFile("$selectedMonthAndYear report", data);
                      },
                      buttonColor: blueColor,
                    ),
                    SizedBox(width: 12.w),
                    CustomSavePdfSendEmailButton(
                      buttonText: AppLocalizations.of(context)
                              ?.reportsScreenSendEmail ??
                          '',
                      onTab: () async {
                        // Share.share('from your download share reports');
                        final data = await PdfServices().createMonthlyReport(
                          monthYearReportName: "$selectedMonthAndYear Report",
                          reportList: listOfFinalReportForPdf,
                          sumList: reportSumList,
                        );

                        final output = await getExternalStorageDirectory();
                        var filePath =
                            "${output?.path}/$selectedMonthAndYear report.pdf";
                        final file = File(filePath);
                        await file.writeAsBytes(data);
                        // Share the PDF file using share_plus
                        Share.shareFiles([file.path],
                            text: 'Check out this PDF file!');
                        // final Uri url = Uri.parse(
                        //     'https://mail.google.com'); // URL for Gmail
                        // if (await launchUrl(url)) {
                        // } else {
                        //   throw Exception('Could not launch $url');
                        // }
                      },
                      buttonColor: greenColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<bool> launchUrl(Uri uri) async {
  //   if (await canLaunch(uri.toString())) {
  //     await launch(uri.toString());
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
