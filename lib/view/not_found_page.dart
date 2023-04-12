import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Page Not Found',
          style: CustomTextStyle.kHeading1,
        ),
      ),
    );
  }
}
