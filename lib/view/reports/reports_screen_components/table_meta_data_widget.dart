import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:one_click_time_sheet/view/reports/edit_delete_history_element_detail_screen.dart';

class TableMetaDataWidget extends StatelessWidget {
  final String jobType;
  final String startTime;
  final String endTime;
  final String difference;
  final String consider;
  final List<HistoryElement>? editDeleteHistoryElement;
  final String indexKey;
  // final List<JobHistoryModel> jobList;
  final int jIndex;
  final int iIndex;
  final int kIndex;

  const TableMetaDataWidget({
    Key? key,
    required this.jobType,
    required this.startTime,
    required this.endTime,
    required this.difference,
    required this.consider,
    required this.editDeleteHistoryElement,
    required this.indexKey,
    // required this.jobList,
    required this.jIndex,
    required this.iIndex,
    required this.kIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      width: double.infinity,
      child: Row(
        children: [
          /// Job type
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
            child: Text(
              jobType,
              style: CustomTextStyle.kBodyText2,
            ),
          ),

          /// Start
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
            child: Text(startTime, style: CustomTextStyle.kBodyText2),
          ),

          /// End
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
              endTime,
              style: CustomTextStyle.kBodyText2,
            ),
          ),

          /// Difference
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
                difference,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),

          /// Considered
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
                consider,
                style: CustomTextStyle.kBodyText2,
              ),
            ),
          ),

          /// Action
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
                GestureDetector(
                  onTap: () {
                    // print(editDeleteHistoryElement);
                    // print('j index: $jIndex');
                    // print('i index: $iIndex');
                    // print('k index: $iIndex');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return EditDeleteHistoryElement(
                          historyElement: editDeleteHistoryElement,
                          listKey: indexKey,
                          // jobList: jobList,
                          iIndex: iIndex,
                          jIndex: jIndex,
                        );
                      },
                    ));
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: redColor,
                    size: 14.h,
                  ),
                ),
                Container(color: Colors.grey, width: 1),
                GestureDetector(
                  onTap: () {
                    // print(jobList);
                    // print(editDeleteHistoryElement);
                    // print('j index: $jIndex');
                    // print('i index: $iIndex');
                    // print('k index: $iIndex');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return EditDeleteHistoryElement(
                          historyElement: editDeleteHistoryElement,
                          listKey: indexKey,
                          // jobList: jobList,
                          iIndex: iIndex,
                          jIndex: jIndex,
                        );
                      },
                    ));
                  },
                  child: Icon(
                    Icons.edit,
                    color: lightGreenColor,
                    size: 14.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
