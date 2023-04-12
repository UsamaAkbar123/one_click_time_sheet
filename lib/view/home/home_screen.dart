import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text("Home Screen",
          style: CustomTextStyle.kHeading1,
        ),
      ),
    );
  }
}
