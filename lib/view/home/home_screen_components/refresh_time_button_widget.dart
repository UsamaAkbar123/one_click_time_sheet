import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
class RefreshTimeWidget extends StatelessWidget {
  final VoidCallback onTab;

  const RefreshTimeWidget({
    super.key,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
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
    );
  }
}
