import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class AppointmentTextWidget extends StatelessWidget {
  final String? title;
  final String? value;
  final Color? valueTextColor;

  const AppointmentTextWidget({
    super.key,
    this.title,
    this.value,
    this.valueTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: CustomTextStyle.kBodyText1.copyWith(
              fontSize: 17.sp,
            ),
          ),
          TextSpan(
            text: value,
            style: CustomTextStyle.kBodyText1.copyWith(
              color: valueTextColor ?? Colors.transparent,
              fontSize: 17.sp,
            ),
          ),
        ],
      ),
    );
  }
}