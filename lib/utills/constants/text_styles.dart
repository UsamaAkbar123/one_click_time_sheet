import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class CustomTextStyle{
  static TextStyle kHeading1 = GoogleFonts.lexend(
    color: blackColor,
    fontSize: 25.sp,
    fontWeight: FontWeight.w700,
  );


  static TextStyle kHeading2 = GoogleFonts.lexend(
    color: blackColor,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  ///Text style for Body text 1
  static TextStyle kBodyText1 = GoogleFonts.lexend(
    color: blackColor,
    fontSize: 14.sp,
    height: 1.5,
    fontWeight: FontWeight.w300,
  );

  static TextStyle kBodyText2 = GoogleFonts.lexend(
    color: blackColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
  );
}
