import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/plus_minus_manual_time_adjustment_for_start_end_job.dart';

class StartEndJobBox extends StatelessWidget {
  final VoidCallback onTab;
  final Color color;
  final IconData iconData;
  final String jobStatus;

  const StartEndJobBox({
    super.key,
    required this.iconData,
    required this.jobStatus,
    required this.color,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Icon(
                iconData,
                size: 100.h,
              ),
              SizedBox(width: 5.w),
              Column(
                children: [
                  Text(
                    jobStatus,
                    style: CustomTextStyle.kHeading1,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '8:00',
                    style: CustomTextStyle.kHeading1,
                  ),
                  Text(
                    'Tuesday, 22,9,2022',
                    style: CustomTextStyle.kBodyText1,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlusMinusManualTimeAdjustmentForStartEndJob(
                onTab: () {},
                text: '-1 min',
              ),
              PlusMinusManualTimeAdjustmentForStartEndJob(
                onTab: () {},
                text: '+1 min',
              ),
              PlusMinusManualTimeAdjustmentForStartEndJob(
                onTab: () {},
                text: 'Manual',
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}