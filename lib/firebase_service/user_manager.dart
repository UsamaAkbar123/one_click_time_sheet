import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/component/loading_widget.dart';
import 'data_backup.dart';

class UserManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Function to register a new user with email and password
  Future<void> registerWithEmail(String email,context) async {
    loadingDialogue(context: context);
    print(_auth.currentUser?.uid);
     await _auth.createUserWithEmailAndPassword(
      email: email,
      password: "123456",
    ).then((value) {
       Navigator.pop(context);
       DataBackup().backupDataToFirebase(context);
     }).catchError((e) async{
       if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
         Navigator.pop(context);
         print("Email already in use, logging in instead");
         await loginWithEmail(email, context).then((value) {
           DataBackup().backupDataToFirebase(context);
         });
       }
       else{
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content:  Text(e.toString()),
             backgroundColor: redColor,
             showCloseIcon: true,
             closeIconColor: whiteColor,
           ),
         );
       }
    });
  }

  // Function to log in with email and password
  Future<void> loginWithEmail(String email,context) async {
    loadingDialogue(context: context);
     await _auth.signInWithEmailAndPassword(
      email: email,
      password: "123456",
    ).then((value) {
     Navigator.pop(context);
     DataBackup().dataRestoreFromFirebase(context);
     }).catchError((e) {
       Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content:  Text(e.toString()),
           backgroundColor: redColor,
           showCloseIcon: true,
           closeIconColor: whiteColor,
         ),
       );
     });
  }
}
