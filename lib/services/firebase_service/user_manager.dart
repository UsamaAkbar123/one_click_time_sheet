import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/component/loading_widget.dart';

class UserManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Function to register a new user with email and password
  Future<void> registerWithEmail(String email, context) async {
    loadingDialogue(context: context);
    debugPrint(_auth.currentUser?.uid);
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: "123456",
    )
        .then((value) async {
      Navigator.pop(context);
      // await DataBackup().backupDataWorkPlan(context).then((value) {
      //   DataBackup().backupDataToFirebase(context);
      // });
    }).catchError((e) async {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        Navigator.pop(context);
        debugPrint("Email already in use, logging in instead");
        await loginWithEmail(email, context);
        // await loginWithEmail(email, context).then((value) async {
        //   await DataBackup().backupDataWorkPlan(context).then((value) {
        //     DataBackup().backupDataToFirebase(context);
        //   });
        // });
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: redColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
      }
    });
  }

  // Function to log in with email and password
  Future<void> loginWithEmail(String email, context) async {
    loadingDialogue(context: context);
    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: "123456",
    )
        .then((value) async {
      Navigator.pop(context);
      // await DataBackup().dataRestoreFromFirebase(context).then((value) {
      //   DataBackup().restoreDataWorkPlan(context);
      // });
    }).catchError((e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: redColor,
          showCloseIcon: true,
          closeIconColor: whiteColor,
        ),
      );
    });
  }
}
