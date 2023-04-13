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
        child: ListView(
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
                children: [
                  // const Spacer(),
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
            SizedBox(height: 12.h),
            StartEndJobBox(
              iconData: Icons.login_outlined,
              jobStatus: 'Start job',
              color: lightGreenColor,
              onTab: () {},
            ),
            SizedBox(height: 8.h),
            StartEndJobBox(
              iconData: Icons.logout_outlined,
              jobStatus: 'End job',
              color: redColor,
              onTab: () {},
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: PaidUnPaidBreakBox(
                    onTab: () {},
                    breakStatus: 'Paid Break',
                    color: greenColor,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: PaidUnPaidBreakBox(
                    onTab: () {},
                    breakStatus: 'Unpaid Break',
                    color: orangeColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'Last history:',
              style: CustomTextStyle.kHeading2,
            ),
          ],
        ),
      ),
    );
  }
}

class PaidUnPaidBreakBox extends StatelessWidget {
  final VoidCallback onTab;
  final String breakStatus;
  final Color color;

  const PaidUnPaidBreakBox({
    super.key,
    required this.onTab,
    required this.breakStatus,
    required this.color,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.coffee_outlined,
                  size: 50.h,
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
      height: 150.h,
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
          SizedBox(height: 8.h),
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
        ],
      ),
    );
  }
}

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

class PlusMinusManualTimeAdjustmentForPaidUnPaid extends StatelessWidget {
  final VoidCallback onTab;
  final String text;

  const PlusMinusManualTimeAdjustmentForPaidUnPaid({
    super.key,
    required this.onTab,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 20.h,
        width: 60.w,
        color: greyColor,
        alignment: Alignment.center,
        child: Text(
          text,
          style: CustomTextStyle.kBodyText2,
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
