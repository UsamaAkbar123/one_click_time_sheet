import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/reports/constant/common_functions.dart';
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

  List<String> idListForPdf = [];
  List<JobHistoryModel> jobHistoryForPdf = [];

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
                          setState(() {
                            if (currentMonth != 1) {
                              currentMonth--;
                              selectedMonth = selectMonth(currentMonth);
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
                              selectedMonth = selectMonth(currentMonth);
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

                              idListForPdf.add(id);

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
                                            jobHistoryForPdf.add(jobList[j]);
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
                        print(idListForPdf.length);
                        print(jobHistoryForPdf.length);
                        final data = await PdfServices()
                            .createHelloWorld(jobHistoryForPdf);
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
