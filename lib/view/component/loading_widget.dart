import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';



loadingDialogue({context}){
  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (c) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          contentPadding:  EdgeInsets.symmetric(horizontal: 25.w,vertical: 25.h),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape:  RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(10.r))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child:  CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}


confirmationDialogue({required BuildContext context, required String title, required String bodyText ,required Function function}){
  showDialog(
      barrierDismissible: false,
      //barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (_) =>
          AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
            contentPadding:  EdgeInsets.only(top: 25.h,left: 25.w,right: 25.w,bottom: 10.h),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:  RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.r))),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width/1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                        ),
                      ),
                       SizedBox(
                        height: 6.h,
                      ),
                       Divider(
                        thickness: 0.7,
                        color: Theme.of(context).dividerColor,
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        bodyText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No',style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16.sp),),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              function();
                            },
                            child: Text('Yes' ,style:Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16.sp),),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
  );
}