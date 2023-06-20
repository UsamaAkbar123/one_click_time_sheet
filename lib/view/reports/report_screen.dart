import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
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
  List listItems = [
    {
      'date': 'Thursday 22-09-2022',
      'titles': ['Work', 'Paid Break', 'Unpaid Break'],
      'Start': ['08:00', '09:34', '12:45'],
      'End': ['12:00', '01:24', '04:32'],
      'Difference': ['03:00', '02:00', '09:12'],
      'Considered': ['01:00', '05:00', '02:12'],
      'isEditing': [false, false, false],
      'isDeleting': [false, false, false],
    },
    {
      'date': 'Thursday 23-09-2022',
      'titles': ['Work', 'Paid Break', 'Unpaid Break'],
      'Start': ['12:00', '09:10', '10:45'],
      'End': ['03:00', '01:24', '04:32'],
      'Difference': ['06:00', '05:00', '03:12'],
      'Considered': ['07:00', '02:00', '07:12'],
      'isEditing': [false, false, false],
      'isDeleting': [false, false, false],
    }
  ];

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
                                itemBuilder: (context, j) {
                                  return Column(
                                    children: [
                                      const HeaderDataOfTable(),
                                      ListView.builder(
                                        itemBuilder: (context, k) {
                                          String startTime = '';
                                          String endTime = '';
                                          int difference = 0;
                                          if (k == 0) {
                                            startTime = DateFormat('h:mm a')
                                                .format(jobList[j]
                                                        .historyElement
                                                        ?.first
                                                        .time ??
                                                    DateTime.now());

                                            endTime = DateFormat('h:mm a')
                                                .format(jobList[j]
                                                        .historyElement
                                                        ?.last
                                                        .time ??
                                                    DateTime.now());
                                          } else {
                                            if (k + 1 <
                                                jobList[j]
                                                    .historyElement!
                                                    .length) {
                                              startTime = DateFormat('h:mm a')
                                                  .format(jobList[j]
                                                          .historyElement?[k]
                                                          .time ??
                                                      DateTime.now());
                                              endTime = DateFormat('h:mm a')
                                                  .format(jobList[j]
                                                          .historyElement?[
                                                              k + 1]
                                                          .time ??
                                                      DateTime.now());
                                            }
                                          }

                                          DateFormat format =
                                              DateFormat('hh:mm a');
                                          DateTime time1 =
                                              format.parse(startTime);
                                          DateTime time2 =
                                              format.parse(endTime);

                                          difference =
                                              time2.difference(time1).inMinutes;

                                          // int difference =
                                          //     int.parse(endTime).toInt() -
                                          //         int.parse(startTime).toInt();

                                          return TableMetaDataWidget(
                                            jobType: k == 0
                                                ? 'work'
                                                : jobList[j]
                                                        .historyElement?[k]
                                                        .type ??
                                                    '',
                                            startTime: startTime,
                                            endTime: endTime,
                                            difference: difference.toString(),
                                            consider: '2:00',
                                          );
                                        },
                                        itemCount:
                                            jobList[j].historyElement!.length -
                                                1,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                      ),
                                      sumBlock(),
                                      SizedBox(height: 15.h),
                                    ],
                                  );
                                },
                                itemCount: jobList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
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

  Widget sumBlock() {
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
                '',
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

  const TableMetaDataWidget({
    Key? key,
    required this.jobType,
    required this.startTime,
    required this.endTime,
    required this.difference,
    required this.consider,
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
                  onTap: () {},
                  child: Icon(
                    Icons.cancel_outlined,
                    color: redColor,
                    size: 14.h,
                  ),
                ),
                Container(color: Colors.grey, width: 1),
                GestureDetector(
                  onTap: () {},
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
