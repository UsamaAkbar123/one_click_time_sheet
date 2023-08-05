import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

Widget sumBlock({required int totalHours, required int totalMinutes}) {
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
              '$totalHours:${totalMinutes.toString().padLeft(2, '0')}',
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
