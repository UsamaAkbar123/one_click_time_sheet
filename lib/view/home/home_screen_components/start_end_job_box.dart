import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/plus_minus_manual_time_adjustment_for_start_end_job.dart';

class StartEndJobBox extends StatelessWidget {
  final VoidCallback? onTab;
  final VoidCallback plusMinuteTap;
  final VoidCallback minusMinuteTap;
  final VoidCallback manualTimeTap;
  final Color color;
  final String jobStatus;
  final int time;
  final DateTime startingDate;

  const StartEndJobBox({
    super.key,
    required this.jobStatus,
    required this.color,
     this.onTab,
    required this.time, required this.startingDate, required this.plusMinuteTap, required this.minusMinuteTap, required this.manualTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 170.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: blackColor,
            width: 3.w,
          ),
        ),
        child: Column(
          children: [
            Text(
              jobStatus,
              style: CustomTextStyle.kHeading1,
            ),
            SizedBox(height: 5.h),
            Text(
              DateFormat('h:mm a').format(startingDate),
              //"${startingDate.hour}:${startingDate.minute}",
              style: CustomTextStyle.kHeading1,
            ),
            Text(
              DateFormat('EEEE, d, M, y').format(startingDate),
              style: CustomTextStyle.kBodyText1,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlusMinusManualTimeAdjustmentForStartEndJob(
                  onTab: minusMinuteTap,
                  text: '-1 min',
                ),
                PlusMinusManualTimeAdjustmentForStartEndJob(
                  onTab: plusMinuteTap,
                  text: '+1 min',
                ),
                PlusMinusManualTimeAdjustmentForStartEndJob(
                  onTab: manualTimeTap,
                  text: 'Manual',
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
