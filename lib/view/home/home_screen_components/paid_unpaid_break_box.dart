import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/managers/preference_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/plus_minus_manual_time_adjust_for_paid_unpaid.dart';

class PaidUnPaidBreakBox extends StatelessWidget {
  final VoidCallback? onTab;
  final String breakStatus;
  final Color color;
  final String iconPath;
  final DateTime startingDate;
  final VoidCallback plusMinuteTap;
  final VoidCallback minusMinuteTap;
  final VoidCallback manualTimeTap;

  static PreferenceManager preferenceManager = PreferenceManager();

  const PaidUnPaidBreakBox({
    super.key,
    this.onTab,
    required this.breakStatus,
    required this.color,
    required this.iconPath,
    required this.plusMinuteTap,
    required this.minusMinuteTap,
    required this.manualTimeTap,
    required this.startingDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 130.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: blackColor,
            width: 3.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                    child: Image.asset(
                      iconPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // SizedBox(width: 5.w),
                  Column(
                    children: [
                      Text(
                        breakStatus,
                        style:
                            CustomTextStyle.kHeading1.copyWith(fontSize: 16.sp),
                      ),
                      SizedBox(height: 5.h),
                      preferenceManager.getTimeFormat == '' ||
                              preferenceManager.getTimeFormat == '12h'
                          ? Text(
                              DateFormat.jm().format(startingDate),
                              style: CustomTextStyle.kHeading1
                                  .copyWith(fontSize: 16.sp),
                            )
                          : Text(
                              DateFormat.Hm().format(startingDate),
                              style: CustomTextStyle.kHeading1
                                  .copyWith(fontSize: 16.sp),
                            ),
                      Text(
                        DateFormat(preferenceManager.getDateFormat)
                            .format(startingDate),
                        style: CustomTextStyle.kBodyText1
                            .copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
              child: Row(
                children: [
                  Expanded(
                    child: PlusMinusManualTimeAdjustmentForPaidUnPaid(
                      onTab: minusMinuteTap,
                      text: '-1 min',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: PlusMinusManualTimeAdjustmentForPaidUnPaid(
                      onTab: plusMinuteTap,
                      text: '+1 min',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: PlusMinusManualTimeAdjustmentForPaidUnPaid(
                      onTab: manualTimeTap,
                      text: 'Manual',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
