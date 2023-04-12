import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/utills/constants/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.helloWorld,
          style: CustomTextStyle.kHeading1,
        ),
      ),
    );
  }
}
