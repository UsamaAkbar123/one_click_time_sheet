import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';


class CustomWorkPlanTime extends StatelessWidget {
  final String startTime;
  final String endTime;

  const CustomWorkPlanTime({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: startTime,
            style: CustomTextStyle.kHeading2.copyWith(
              color: lightGreenColor,
            ),
          ),
          TextSpan(
            text: '-',
            style: CustomTextStyle.kHeading2,
          ),
          TextSpan(
            text: endTime,
            style: CustomTextStyle.kHeading2.copyWith(
              color: redColor,
            ),
          ),
        ],
      ),
    );
  }
}