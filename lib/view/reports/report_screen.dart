import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/reports/pdf_services/pdf_services.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/custom_save_pdf_send_email_button.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/header_date_of_table.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/sum_block_widget.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/table_meta_data_widget.dart';

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

  selectMonth(val) {
    switch (val) {
      case 1:
        selectedMonth = 'January';
        break;
      case 2:
        selectedMonth = 'February';
        break;
      case 3:
        selectedMonth = 'March';
        break;
      case 4:
        selectedMonth = 'April';
        break;
      case 5:
        selectedMonth = 'May';
        break;
      case 6:
        selectedMonth = 'June';
        break;
      case 7:
        selectedMonth = 'July';
        break;
      case 8:
        selectedMonth = 'August';
        break;
      case 9:
        selectedMonth = 'September';
        break;
      case 10:
        selectedMonth = 'October';
        break;
      case 11:
        selectedMonth = 'November';
        break;
      case 12:
        selectedMonth = 'December';
        break;
    }
  }

  @override
  void initState() {
    selectMonth(currentMonth);
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
                          setState(() {
                            if (currentMonth != 1) {
                              currentMonth--;
                              selectMonth(currentMonth);
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
                          setState(() {
                            if (currentMonth != 12) {
                              currentMonth++;
                              selectMonth(currentMonth);
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
                          return ListView.builder(
                            itemCount: box.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              List<JobHistoryModel> jobList =
                                  box.getAt(i).cast<JobHistoryModel>();
                              String id = box.keyAt(i);

                              jobList = jobList.where((job) {
                                return job.timestamp.month == currentMonth;
                              }).toList();

                              jobList.sort(
                                (a, b) => b.timestamp.compareTo(a.timestamp),
                              );
                              return jobList.isEmpty
                                  ? Center(
                                      child: i == 0
                                          ? const Text(
                                              'No Data Found for this month')
                                          : const SizedBox(),
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
                                            int totalHoursForFinalSumResult = 0;
                                            int totalMinutesForFinalSumResult =
                                                0;
                                            List<HistoryElement>?
                                                historyElementList =
                                                jobList[j].historyElement ?? [];

                                            // historyElementList =
                                            //     historyElementList?.reversed.toList();
                                            historyElementList.sort(
                                              (a, b) => a.time!.compareTo(
                                                  b.time ?? DateTime.now()),
                                            );
                                            return Column(
                                              children: [
                                                const HeaderDataOfTable(),
                                                ListView.builder(
                                                  // itemCount:
                                                  //     jobList[j].historyElement!.length -
                                                  //         1,
                                                  itemCount: historyElementList
                                                          .length -
                                                      1,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, k) {
                                                    // for (int m = 0;
                                                    //     m < historyElementList!.length;
                                                    //     m++) {
                                                    //   print(historyElementList[m].type);
                                                    // }

                                                    String startTime = '';
                                                    String endTime = '';

                                                    // int difference = 0;
                                                    int hours = 0;
                                                    int minutes = 0;
                                                    if (k == 0) {
                                                      startTime = preferenceManager
                                                                  .getTimeFormat ==
                                                              '12h'
                                                          ? DateFormat('h:mm a')
                                                              .format(
                                                                  historyElementList
                                                                          .first
                                                                          .time ??
                                                                      DateTime
                                                                          .now())
                                                          : DateFormat.Hm().format(
                                                              historyElementList
                                                                      .first
                                                                      .time ??
                                                                  DateTime
                                                                      .now());

                                                      endTime = preferenceManager
                                                                  .getTimeFormat ==
                                                              '12h'
                                                          ? DateFormat('h:mm a')
                                                              .format(
                                                                  historyElementList
                                                                          .last
                                                                          .time ??
                                                                      DateTime
                                                                          .now())
                                                          : DateFormat.Hm().format(
                                                              historyElementList
                                                                      .last
                                                                      .time ??
                                                                  DateTime
                                                                      .now());
                                                      DateTime startDateTime =
                                                          DateTime(
                                                              historyElementList
                                                                      .first
                                                                      .time
                                                                      ?.year ??
                                                                  0,
                                                              historyElementList
                                                                      .first
                                                                      .time
                                                                      ?.month ??
                                                                  0,
                                                              historyElementList
                                                                      .first
                                                                      .time
                                                                      ?.day ??
                                                                  0,
                                                              historyElementList
                                                                      .first
                                                                      .time
                                                                      ?.hour ??
                                                                  0,
                                                              historyElementList
                                                                      .first
                                                                      .time
                                                                      ?.minute ??
                                                                  0);
                                                      DateTime endDateTime =
                                                          DateTime(
                                                              historyElementList
                                                                      .last
                                                                      .time
                                                                      ?.year ??
                                                                  0,
                                                              historyElementList
                                                                      .last
                                                                      .time
                                                                      ?.month ??
                                                                  0,
                                                              historyElementList
                                                                      .last
                                                                      .time
                                                                      ?.day ??
                                                                  0,
                                                              historyElementList
                                                                      .last
                                                                      .time
                                                                      ?.hour ??
                                                                  0,
                                                              historyElementList
                                                                      .last
                                                                      .time
                                                                      ?.minute ??
                                                                  0);

                                                      Duration difference =
                                                          endDateTime.difference(
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
                                                        startTime = preferenceManager
                                                                    .getTimeFormat ==
                                                                '12h'
                                                            ? DateFormat(
                                                                    'h:mm a')
                                                                .format(historyElementList[
                                                                            k]
                                                                        .time ??
                                                                    DateTime
                                                                        .now())
                                                            : DateFormat.Hm().format(
                                                                historyElementList[
                                                                            k]
                                                                        .time ??
                                                                    DateTime
                                                                        .now());
                                                        endTime = preferenceManager
                                                                    .getTimeFormat ==
                                                                '12h'
                                                            ? DateFormat(
                                                                    'h:mm a')
                                                                .format(historyElementList[k +
                                                                            1]
                                                                        .time ??
                                                                    DateTime
                                                                        .now())
                                                            : DateFormat.Hm().format(
                                                                historyElementList[
                                                                            k +
                                                                                1]
                                                                        .time ??
                                                                    DateTime
                                                                        .now());

                                                        DateTime startDateTime = DateTime(
                                                            historyElementList[
                                                                        k]
                                                                    .time
                                                                    ?.year ??
                                                                0,
                                                            historyElementList[
                                                                        k]
                                                                    .time
                                                                    ?.month ??
                                                                0,
                                                            historyElementList[
                                                                        k]
                                                                    .time
                                                                    ?.day ??
                                                                0,
                                                            historyElementList[
                                                                        k]
                                                                    .time
                                                                    ?.hour ??
                                                                0,
                                                            historyElementList[
                                                                        k]
                                                                    .time
                                                                    ?.minute ??
                                                                0);
                                                        DateTime endDateTime = DateTime(
                                                            historyElementList[
                                                                        k + 1]
                                                                    .time
                                                                    ?.year ??
                                                                0,
                                                            historyElementList[
                                                                        k + 1]
                                                                    .time
                                                                    ?.month ??
                                                                0,
                                                            historyElementList[
                                                                        k + 1]
                                                                    .time
                                                                    ?.day ??
                                                                0,
                                                            historyElementList[
                                                                        k + 1]
                                                                    .time
                                                                    ?.hour ??
                                                                0,
                                                            historyElementList[
                                                                        k + 1]
                                                                    .time
                                                                    ?.minute ??
                                                                0);

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
                                                            'Unpaid break') {
                                                          totalHoursForFinalSumResult =
                                                              totalHoursForFinalSumResult -
                                                                  hours;

                                                          totalMinutesForFinalSumResult =
                                                              totalMinutesForFinalSumResult -
                                                                  minutes;
                                                        }
                                                      }
                                                    }

                                                    return Column(
                                                      children: [
                                                        if (k == 0)
                                                          TableMetaDataWidget(
                                                            jobType: 'work',
                                                            startTime:
                                                                startTime,
                                                            endTime: endTime,
                                                            difference:
                                                                '$hours:${minutes.toString().padLeft(2, '0')}',
                                                            consider:
                                                                '$hours:${minutes.toString().padLeft(2, '0')}',
                                                            editDeleteHistoryElement:
                                                                historyElementList,
                                                            indexKey: id,
                                                            // jobList: jobList,
                                                            jIndex: j,
                                                            iIndex: i,
                                                            kIndex: k,
                                                          ),
                                                        historyElementList[k]
                                                                    .type ==
                                                                'Start job'
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
                                                                        'Unpaid break'
                                                                    ? '-$hours:${minutes.toString().padLeft(2, '0')}'
                                                                    : historyElementList[k].type ==
                                                                            'Paid break'
                                                                        ? '0:00'
                                                                        : '$hours:${minutes.toString().padLeft(2, '0')}',
                                                                editDeleteHistoryElement:
                                                                    historyElementList,
                                                                indexKey: id,
                                                                jIndex: j,
                                                                iIndex: i,
                                                                kIndex: k,
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
                        final data = await PdfServices().createHelloWorld();
                        PdfServices().savePdfFile('external_files', data);
                      },
                      buttonColor: blueColor,
                    ),
                    SizedBox(width: 12.w),
                    CustomSavePdfSendEmailButton(
                      buttonText: AppLocalizations.of(context)
                              ?.reportsScreenSendEmail ??
                          '',
                      onTab: () {},
                      buttonColor: greenColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
