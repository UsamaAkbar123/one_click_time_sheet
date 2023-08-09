import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/component/loading_widget.dart';

class DataBackup{
  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  User? user = FirebaseAuth.instance.currentUser;
 Future<void> dataRestoreFromFirebase(context) async{
      try{
        print(user?.uid);
        loadingDialogue(context: context);
        final DocumentReference document = FirebaseFirestore.instance.collection('backup').doc(user?.uid);
        final DocumentSnapshot snapshot = await document.get();

        if (snapshot.exists) {
          final Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

          // Check if dataMap is empty
          if (dataMap.isEmpty) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("No backup data found in Firebase."),
                  // Replace with the appropriate colors for your application
                  backgroundColor: redColor,
                  showCloseIcon: true,
                  closeIconColor: whiteColor,
                ),
              );
            return; // Exit the function if no data is found
          }

          // Iterate through existing data in Hive box and merge with restored data from Firebase
          dataMap.forEach((key, value) {
            List<Map<String, dynamic>> listMap = List<Map<String, dynamic>>.from(value);
            List<JobHistoryModel> firebaseJobList = listMap.map((item) => JobHistoryModel.firebaseJson(item)).toList();
            List<JobHistoryModel> existingJobList = jobHistoryBox.get(key)?.cast<JobHistoryModel>() ?? [];

            // Merge the lists, avoiding duplicates based on unique IDs
            for (var job in firebaseJobList) {
              if (!existingJobList.any((existingJob) => existingJob.uuid == job.uuid)) {
                existingJobList.add(job);
              }
            }

            // Put the merged data back into the Hive box with the corresponding key
            jobHistoryBox.put(key, existingJobList);
          });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("data has been restored successfully"),
                // Replace with the appropriate colors for your application
                backgroundColor: greenColor,
                showCloseIcon: true,
                closeIconColor: whiteColor,
              ),
            );
        } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("No backup document found in Firebase."),
                // Replace with the appropriate colors for your application
                backgroundColor: redColor,
                showCloseIcon: true,
                closeIconColor: whiteColor,
              ),
            );
        }

      }
      catch(e){
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:  Text(e.toString()),
            // Replace with the appropriate colors for your application
            backgroundColor: redColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
      }
  }


 Future<void> backupDataToFirebase(context) async{
   try{
     loadingDialogue(context: context);
       if(jobHistoryBox.isNotEmpty){
         final CollectionReference collection = FirebaseFirestore.instance.collection('backup');
         final DocumentReference document = collection.doc(user?.uid);
         final DocumentSnapshot snapshot = await document.get();
         //   // Convert the existing data in Firebase into a convenient format
         Map<String, List<JobHistoryModel>> existingData = {};
         if (snapshot.exists) {
           Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
           dataMap.forEach((key, value) {
             List<Map<String, dynamic>> listMap = List<Map<String, dynamic>>.from(value);
             existingData[key] = listMap.map((item) => JobHistoryModel.firebaseJson(item)).toList();
             print(existingData);
           });
         }

         // Compare the Hive data with the existing data in Firebase
         for (int i = 0; i < jobHistoryBox.length; i++) {
           String dataKey = jobHistoryBox.keyAt(i);
           List<JobHistoryModel> jobList = jobHistoryBox.getAt(i).cast<JobHistoryModel>();

           // Get the existing list for this key, or an empty list if none exists
           List<JobHistoryModel> existingList = existingData[dataKey] ?? [];

           // Add only the new entries to the existing list
           for (var job in jobList) {
             if (!existingList.any((existingJob) => existingJob.uuid == job.uuid)) {
               existingList.add(job);
             }
           }

           // Update the existing data with the new combined list
           existingData[dataKey] = existingList;
         }

         // Convert the existing data into the format for Firestore
         Map<String, dynamic> allData = {};
         existingData.forEach((key, value) {
           allData[key] = value.map((item) => item.toJson()).toList();
         });

         // Update the document in Firestore with the combined data
         //  await document.delete();
         await document.set(allData).then((value)  {
           Navigator.of(context).pop();
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content:  const Text("data is successfully stored"),
               backgroundColor: greenColor,
               showCloseIcon: true,
               closeIconColor: whiteColor,
             ),
           );
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
       }else{
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: const Text('No data is available for backup'),
             backgroundColor: redColor,
             showCloseIcon: true,
             closeIconColor: whiteColor,
           ),
         );
       }

     }
   catch(e){
     Navigator.pop(context);
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content:  Text(e.toString()),
         // Replace with the appropriate colors for your application
         backgroundColor: redColor,
         showCloseIcon: true,
         closeIconColor: whiteColor,
       ),
     );
   }
  }


}