import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/home/home_screen_components/plus_minus_manual_time_adjust_for_paid_unpaid.dart';

class PaidUnPaidBreakBox extends StatelessWidget {
  final VoidCallback? onTab;
  final String breakStatus;
  final Color color;
  final String iconPath;

  const PaidUnPaidBreakBox({
    super.key,
     this.onTab,
    required this.breakStatus,
    required this.color,
    required this.iconPath,
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
                  // Icon(
                  //   Icons.coffee_outlined,
                  //   size: 50.h,
                  // ),
                  SizedBox(
                    height: 40.h,
                    child: Image.asset(iconPath,fit: BoxFit.cover,),
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
                      Text(
                        '8:00',
                        style:
                            CustomTextStyle.kHeading1.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                        'Tuesday, 22,9,2022',
                        style:
                            CustomTextStyle.kBodyText1.copyWith(fontSize: 11.sp),
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
                      onTab: () {},
                      text: '-1 min',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: PlusMinusManualTimeAdjustmentForPaidUnPaid(
                      onTab: () {},
                      text: '+1 min',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: PlusMinusManualTimeAdjustmentForPaidUnPaid(
                      onTab: () {},
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
