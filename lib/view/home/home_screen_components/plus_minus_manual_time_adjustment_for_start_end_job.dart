import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class PlusMinusManualTimeAdjustmentForStartEndJob extends StatelessWidget {
  final VoidCallback onTab;
  final String text;

  const PlusMinusManualTimeAdjustmentForStartEndJob({
    super.key,
    required this.onTab,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 30.h,
        width: 90.w,
        color: greyColor,
        alignment: Alignment.center,
        child: Text(
          text,
          style: CustomTextStyle.kBodyText1,
        ),
      ),
    );
  }
}