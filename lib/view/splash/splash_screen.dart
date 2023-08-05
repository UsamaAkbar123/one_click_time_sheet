import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/routes/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // changeLocal(context: context, language: PreferenceManager().getLanguage);
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed(
        bottomNavBarScreenRoute,
        // arguments: -1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
