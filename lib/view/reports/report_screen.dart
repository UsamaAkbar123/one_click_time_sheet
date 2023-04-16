import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
          'Reports',
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
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSavePdfSendEmailButton(
                  buttonText: 'save to pdf',
                  onTab: (){},
                  buttonColor: blueColor,
                ),
                SizedBox(width: 12.w),
                CustomSavePdfSendEmailButton(
                  buttonText: 'send email',
                  onTab: (){},
                  buttonColor: greenColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSavePdfSendEmailButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTab;
  final Color buttonColor;
  const CustomSavePdfSendEmailButton({
    super.key,
    required this.buttonText,
    required this.onTab,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: 100.w,
        height: 30.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: buttonColor,
        ),
        child: Text(
          buttonText,
          style: CustomTextStyle.kBodyText1.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
