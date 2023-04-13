import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.homeScreenTitle,
          style: CustomTextStyle.kHeading2,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: blackColor),
              ),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.homeScreenPlan ?? '',
                    style: CustomTextStyle.kHeading2,
                  ),
                  SizedBox(width: 10.w),
                  const CustomWorkPlanTime(
                    startTime: '8:00',
                    endTime: '11:30',
                  ),
                  Text(
                    ',',
                    style: CustomTextStyle.kHeading2,
                  ),
                  SizedBox(width: 5.w),
                  const CustomWorkPlanTime(
                    startTime: '12:00',
                    endTime: '15:00',
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: greyColor,
                      size: 30.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: blueColor,
                border: Border.all(
                  color: blackColor,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [// const Spacer(),
                  Icon(
                    Icons.refresh,
                    color: blackColor,
                    size: 40.h,
                  ),
                  SizedBox(width: 2.w),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)?.homeScreenRefreshTime ?? '',
                      style: CustomTextStyle.kBodyText1.copyWith(
                        fontSize: 22.sp,
                        color: whiteColor,
                      ),
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
