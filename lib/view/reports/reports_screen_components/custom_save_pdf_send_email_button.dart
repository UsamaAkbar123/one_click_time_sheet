import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

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


