import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_click_time_sheet/firebase_service/user_manager.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
class AlertBoxForAskingEmail extends StatefulWidget {
  final bool isSignupFunction;
  const AlertBoxForAskingEmail({Key? key, required this.isSignupFunction}) : super(key: key);

  @override
  State<AlertBoxForAskingEmail> createState() => _AlertBoxForAskingEmailState();
}

class _AlertBoxForAskingEmailState extends State<AlertBoxForAskingEmail> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: CustomTextStyle.kHeading2.copyWith(
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              style: CustomTextStyle.kBodyText2,
              decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  label: Text(
                    'enter your email',
                    style: CustomTextStyle.kBodyText2,
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the work plan name';
                }
                else if (!EmailValidator.validate(value)) {
                  return 'enter a valid email';
                }
                else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              if(widget.isSignupFunction){
                UserManager().registerWithEmail(emailController.text, context);
              }
              else{
                UserManager().loginWithEmail(emailController.text, context);
              }
            }
          },
          child: const Text("save"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("cancel"),
        ),
      ],
    );
  }
}
