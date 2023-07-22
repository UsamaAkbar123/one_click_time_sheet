import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_click_time_sheet/view/reports/reports_screen_components/custom_save_pdf_send_email_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final Box box = Hive.box('jobHistoryBox');
  String selectedMonth = '';
  String selectedMonthAndYear = '';
  DateTime? selectedDate;
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
        child: ListView(
          children: [
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                final initialDate = DateTime.now();
                final newData = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: DateTime(DateTime.now().year + 5));
                if (newData == null) return;
                selectMonth(newData.month);
                selectedMonthAndYear = '$selectedMonth ${newData.year}';
                setState(
                  () {
                    selectedDate = newData;
                  },
                );
              },
              child: Container(
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
                      onTap: null,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: blackColor,
                        size: 18.h,
                      ),
                    ),
                    Text(
                      selectedMonthAndYear == ''
                          ? 'September 2022'
                          : selectedMonthAndYear,
                      style: CustomTextStyle.kBodyText1.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: null,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: blackColor,
                        size: 18.h,
                      ),
                    ),
                  ],
                ),
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
                          jobList.sort(
                              (a, b) => b.timestamp.compareTo(a.timestamp));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 13.h),
                              Text(
                                id,
                                style: CustomTextStyle.kBodyText1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              ListView.builder(
                                itemCount: jobList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, j) {
                                  int totalHoursForFinalSumResult = 0;
                                  int totalMinutesForFinalSumResult = 0;
                                  List<HistoryElement>? historyElementList =
                                      jobList[j].historyElement;

                                  // historyElementList =
                                  //     historyElementList?.reversed.toList();
                                  return Column(
                                    children: [
                                      const HeaderDataOfTable(),
                                      ListView.builder(
                                        // itemCount:
                                        //     jobList[j].historyElement!.length -
                                        //         1,
                                        itemCount:
                                            historyElementList!.length - 1,
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
                                                ? DateFormat('h:mm a').format(
                                                    historyElementList
                                                            .first.time ??
                                                        DateTime.now())
                                                : DateFormat.Hm().format(
                                                    historyElementList
                                                            .first.time ??
                                                        DateTime.now());

                                            endTime = preferenceManager
                                                        .getTimeFormat ==
                                                    '12h'
                                                ? DateFormat('h:mm a').format(
                                                    historyElementList
                                                            .last.time ??
                                                        DateTime.now())
                                                : DateFormat.Hm().format(
                                                    historyElementList
                                                            .last.time ??
                                                        DateTime.now());
                                            DateTime startDateTime = DateTime(
                                                historyElementList
                                                        .first.time?.year ??
                                                    0,
                                                historyElementList
                                                        .first.time?.month ??
                                                    0,
                                                historyElementList
                                                        .first.time?.day ??
                                                    0,
                                                historyElementList
                                                        .first.time?.hour ??
                                                    0,
                                                historyElementList
                                                        .first.time?.minute ??
                                                    0);
                                            DateTime endDateTime = DateTime(
                                                historyElementList
                                                        .last.time?.year ??
                                                    0,
                                                historyElementList
                                                        .last.time?.month ??
                                                    0,
                                                historyElementList
                                                        .last.time?.day ??
                                                    0,
                                                historyElementList
                                                        .last.time?.hour ??
                                                    0,
                                                historyElementList
                                                        .last.time?.minute ??
                                                    0);

                                            Duration difference = endDateTime
                                                .difference(startDateTime);
                                            hours = difference.inHours;
                                            minutes = difference.inMinutes
                                                .remainder(60);

                                            totalHoursForFinalSumResult =
                                                totalHoursForFinalSumResult +
                                                    hours;

                                            totalMinutesForFinalSumResult =
                                                totalMinutesForFinalSumResult +
                                                    minutes;
                                          } else {
                                            if (k + 1 <
                                                historyElementList.length) {
                                              startTime = preferenceManager
                                                          .getTimeFormat ==
                                                      '12h'
                                                  ? DateFormat('h:mm a').format(
                                                      historyElementList[k]
                                                              .time ??
                                                          DateTime.now())
                                                  : DateFormat.Hm().format(
                                                      historyElementList[k]
                                                              .time ??
                                                          DateTime.now());
                                              endTime = preferenceManager
                                                          .getTimeFormat ==
                                                      '12h'
                                                  ? DateFormat('h:mm a').format(
                                                      historyElementList[k + 1]
                                                              .time ??
                                                          DateTime.now())
                                                  : DateFormat.Hm().format(
                                                      historyElementList[k + 1]
                                                              .time ??
                                                          DateTime.now());

                                              DateTime startDateTime = DateTime(
                                                  historyElementList[k]
                                                          .time
                                                          ?.year ??
                                                      0,
                                                  historyElementList[k]
                                                          .time
                                                          ?.month ??
                                                      0,
                                                  historyElementList[k]
                                                          .time
                                                          ?.day ??
                                                      0,
                                                  historyElementList[k]
                                                          .time
                                                          ?.hour ??
                                                      0,
                                                  historyElementList[k]
                                                          .time
                                                          ?.minute ??
                                                      0);
                                              DateTime endDateTime = DateTime(
                                                  historyElementList[k + 1]
                                                          .time
                                                          ?.year ??
                                                      0,
                                                  historyElementList[k + 1]
                                                          .time
                                                          ?.month ??
                                                      0,
                                                  historyElementList[k + 1]
                                                          .time
                                                          ?.day ??
                                                      0,
                                                  historyElementList[k + 1]
                                                          .time
                                                          ?.hour ??
                                                      0,
                                                  historyElementList[k + 1]
                                                          .time
                                                          ?.minute ??
                                                      0);

                                              Duration difference = endDateTime
                                                  .difference(startDateTime);
                                              hours = difference.inHours;
                                              minutes = difference.inMinutes
                                                  .remainder(60);
                                              if (historyElementList[k].type ==
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
                                                  startTime: startTime,
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
                                              historyElementList[k].type ==
                                                      'Start job'
                                                  ? const SizedBox()
                                                  : TableMetaDataWidget(
                                                      jobType:
                                                          historyElementList[k]
                                                                  .type ??
                                                              '',
                                                      startTime: startTime,
                                                      endTime: endTime,
                                                      difference:
                                                          '$hours:${minutes.toString().padLeft(2, '0')}',
                                                      consider: historyElementList[
                                                                      k]
                                                                  .type ==
                                                              'Unpaid break'
                                                          ? '-$hours:${minutes.toString().padLeft(2, '0')}'
                                                          : historyElementList[
                                                                          k]
                                                                      .type ==
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
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSavePdfSendEmailButton(
                  buttonText:
                      AppLocalizations.of(context)?.reportsScreenSaveToPdf ??
                          '',
                  onTab: () {},
                  buttonColor: blueColor,
                ),
                SizedBox(width: 12.w),
                CustomSavePdfSendEmailButton(
                  buttonText:
                      AppLocalizations.of(context)?.reportsScreenSendEmail ??
                          '',
                  onTab: () {},
                  buttonColor: greenColor,
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget sumBlock({required int totalHours, required int totalMinutes}) {
    return SizedBox(
      height: 30.h,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.only(left: 3.w),
            child: Text('Sum', style: CustomTextStyle.kBodyText2),
          ),
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              '',
              style: CustomTextStyle.kBodyText2,
            ),
          ),
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              '',
              style: CustomTextStyle.kBodyText2,
            ),
          ),
          Expanded(
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: Text(
                '',
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: Text(
                '$totalHours:${totalMinutes.toString().padLeft(2, '0')}',
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                Container(color: Colors.grey, width: 1),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderDataOfTable extends StatelessWidget {
  const HeaderDataOfTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              // 'sr_no',
              '',
              style: CustomTextStyle.kBodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              'Start',
              style: CustomTextStyle.kBodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              'End',
              style: CustomTextStyle.kBodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: Text(
                'Difference',
                style: CustomTextStyle.kBodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: Text(
                'Considered',
                style: CustomTextStyle.kBodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              'Action',
              style: CustomTextStyle.kBodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableMetaDataWidget extends StatelessWidget {
  final String jobType;
  final String startTime;
  final String endTime;
  final String difference;
  final String consider;
  final List<HistoryElement>? editDeleteHistoryElement;
  final String indexKey;
  // final List<JobHistoryModel> jobList;
  final int jIndex;
  final int iIndex;
  final int kIndex;

  const TableMetaDataWidget({
    Key? key,
    required this.jobType,
    required this.startTime,
    required this.endTime,
    required this.difference,
    required this.consider,
    required this.editDeleteHistoryElement,
    required this.indexKey,
    // required this.jobList,
    required this.jIndex,
    required this.iIndex,
    required this.kIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      width: double.infinity,
      child: Row(
        children: [
          /// Job type
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              jobType,
              style: CustomTextStyle.kBodyText2,
            ),
          ),

          /// Start
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(startTime, style: CustomTextStyle.kBodyText2),
          ),

          /// End
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Text(
              endTime,
              style: CustomTextStyle.kBodyText2,
            ),
          ),

          /// Difference
          Expanded(
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: Text(
                difference,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),

          /// Considered
          Expanded(
            child: Container(
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: Text(
                consider,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),

          /// Action
          Container(
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    // print(editDeleteHistoryElement);
                    // print('j index: $jIndex');
                    // print('i index: $iIndex');
                    // print('k index: $iIndex');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return EditDeleteHistoryElement(
                          historyElement: editDeleteHistoryElement,
                          listKey: indexKey,
                          // jobList: jobList,
                          iIndex: iIndex,
                          jIndex: jIndex,
                        );
                      },
                    ));
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: redColor,
                    size: 14.h,
                  ),
                ),
                Container(color: Colors.grey, width: 1),
                GestureDetector(
                  onTap: () {
                    // print(jobList);
                    // print(editDeleteHistoryElement);
                    // print('j index: $jIndex');
                    // print('i index: $iIndex');
                    // print('k index: $iIndex');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return EditDeleteHistoryElement(
                          historyElement: editDeleteHistoryElement,
                          listKey: indexKey,
                          // jobList: jobList,
                          iIndex: iIndex,
                          jIndex: jIndex,
                        );
                      },
                    ));
                  },
                  child: Icon(
                    Icons.edit,
                    color: lightGreenColor,
                    size: 14.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditDeleteHistoryElement extends StatefulWidget {
  final List<HistoryElement>? historyElement;
  final String listKey;
  // final List<JobHistoryModel> jobList;
  final int iIndex;
  final int jIndex;

  const EditDeleteHistoryElement({
    required this.historyElement,
    required this.listKey,
    // required this.jobList,
    required this.iIndex,
    required this.jIndex,
    super.key,
  });

  @override
  State<EditDeleteHistoryElement> createState() =>
      _EditDeleteHistoryElementState();
}

class _EditDeleteHistoryElementState extends State<EditDeleteHistoryElement> {
  PreferenceManager preferenceManager = PreferenceManager();
  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  List<dynamic> jobList = [];

  @override
  void initState() {
    super.initState();
    jobList = jobHistoryBox.get(widget.listKey);
    // print(jobList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit & Delete',
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          TextEditingController jobNameController =
              TextEditingController(text: widget.historyElement?[index].type);
          DateTime? jobTime = widget.historyElement?[index].time;

          String showJobTime = preferenceManager.getTimeFormat == '12h'
              ? DateFormat.jm().format(jobTime ?? DateTime.now())
              : DateFormat.Hm().format(jobTime ?? DateTime.now());

          String dateOfJob = DateFormat(preferenceManager.getDateFormat)
              .format(jobTime ?? DateTime.now());

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      height: 28.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(
                          color: blackColor.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        key: UniqueKey(),
                        textAlign: TextAlign.center,
                        controller: jobNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            // left: 4.w,
                            bottom: 16.h,
                          ),
                        ),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      height: 28.h,
                      width: 55.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(
                          color: blackColor.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        showJobTime,
                        style: CustomTextStyle.kBodyText1
                            .copyWith(fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      height: 28.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(
                          color: blackColor.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dateOfJob,
                        style: CustomTextStyle.kBodyText1
                            .copyWith(fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(width: 5.w),

                    /// Save Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 28.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Save',
                          style: CustomTextStyle.kBodyText1.copyWith(
                              fontSize: 12.sp,
                              color: whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),

                    /// Delete Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // jobList[widget.iIndex][widget.jIndex]['historyElement']
                        //     .removeAt(index)
                        //     .put(widget.listKey, jobList);
                        // widget.jobList[widget.jIndex].historyElement[index]
                      },
                      child: Container(
                        height: 28.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: redColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Delete',
                          style: CustomTextStyle.kBodyText1.copyWith(
                              fontSize: 12.sp,
                              color: whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: widget.historyElement?.length ?? 0,
      ),
    );
  }
}
