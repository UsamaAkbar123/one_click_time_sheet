import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:one_click_time_sheet/model/hive_job_history_model.dart';
import 'package:one_click_time_sheet/model/work_plan_model.dart';
import 'package:one_click_time_sheet/utills/constants/colors.dart';
import 'package:one_click_time_sheet/view/component/loading_widget.dart';

class DataBackup {
  final Box jobHistoryBox = Hive.box('jobHistoryBox');
  final Box box = Hive.box('workPlan');
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> dataRestoreFromFirebase(context) async {
    try {
      loadingDialogue(context: context);
      final DocumentReference document =
          FirebaseFirestore.instance.collection('backup').doc(user?.uid);
      final DocumentSnapshot snapshot = await document.get();

      if (snapshot.exists) {
        final Map<String, dynamic> dataMap =
            snapshot.data() as Map<String, dynamic>;

        // Check if dataMap is empty
        if (dataMap.isEmpty) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("No job data data is available to restore"),
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
          List<Map<String, dynamic>> listMap =
              List<Map<String, dynamic>>.from(value);
          List<JobHistoryModel> firebaseJobList = listMap
              .map((item) => JobHistoryModel.firebaseJson(item))
              .toList();
          List<JobHistoryModel> existingJobList =
              jobHistoryBox.get(key)?.cast<JobHistoryModel>() ?? [];

          // Merge the lists, avoiding duplicates based on unique IDs
          for (var job in firebaseJobList) {
            if (!existingJobList
                .any((existingJob) => existingJob.uuid == job.uuid)) {
              existingJobList.add(job);
            }
          }

          // Put the merged data back into the Hive box with the corresponding key
          jobHistoryBox.put(key, existingJobList);
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text("Job history data has been restored successfully"),
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
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          // Replace with the appropriate colors for your application
          backgroundColor: redColor,
          showCloseIcon: true,
          closeIconColor: whiteColor,
        ),
      );
    }
  }

  Future<void> backupDataToFirebase(context) async {
    try {
      loadingDialogue(context: context);
      if (jobHistoryBox.isNotEmpty) {
        final CollectionReference collection =
            FirebaseFirestore.instance.collection('backup');
        final DocumentReference document = collection.doc(user?.uid);
        final DocumentSnapshot snapshot = await document.get();
        //   // Convert the existing data in Firebase into a convenient format
        Map<String, List<JobHistoryModel>> existingData = {};
        if (snapshot.exists) {
          Map<String, dynamic> dataMap =
              snapshot.data() as Map<String, dynamic>;
          dataMap.forEach((key, value) {
            List<Map<String, dynamic>> listMap =
                List<Map<String, dynamic>>.from(value);
            existingData[key] = listMap
                .map((item) => JobHistoryModel.firebaseJson(item))
                .toList();
            debugPrint(existingData.toString());
          });
        }
        bool isDataExistForBackup = false;
        // Compare the Hive data with the existing data in Firebase
        for (int i = 0; i < jobHistoryBox.length; i++) {
          String dataKey = jobHistoryBox.keyAt(i);
          List<JobHistoryModel> jobList =
              jobHistoryBox.getAt(i).cast<JobHistoryModel>();

          // Get the existing list for this key, or an empty list if none exists
          List<JobHistoryModel> existingList = existingData[dataKey] ?? [];
          // List<JobHistoryModel> tempList = existingList;
          // Add only the new entries to the existing list
          for (var job in jobList) {
            if (!existingList
                .any((existingJob) => existingJob.uuid == job.uuid)) {
              isDataExistForBackup = true;
              existingList.add(job);
            }
          }
          // Update the existing data with the new combined list
          existingData[dataKey] = existingList;
        }

        if (!isDataExistForBackup) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No job data is available for backup'),
              backgroundColor: redColor,
              showCloseIcon: true,
              closeIconColor: whiteColor,
            ),
          );
          return;
        }

        // Convert the existing data into the format for Firestore
        Map<String, dynamic> allData = {};
        existingData.forEach((key, value) {
          allData[key] = value.map((item) => item.toJson()).toList();
        });

        // Update the document in Firestore with the combined data
        //  await document.delete();
        await document.set(allData).then((value) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("job history data is successfully stored"),
              backgroundColor: greenColor,
              showCloseIcon: true,
              closeIconColor: whiteColor,
            ),
          );
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
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No new job data is available for backup'),
            backgroundColor: redColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          // Replace with the appropriate colors for your application
          backgroundColor: redColor,
          showCloseIcon: true,
          closeIconColor: whiteColor,
        ),
      );
    }
  }

  Future<void> restoreDataWorkPlan(BuildContext context) async {
    try {
      loadingDialogue(context: context);
      final workPlanBox = Hive.box('workPlan');
      final CollectionReference workPlanCollection =
          FirebaseFirestore.instance.collection('workPlanBackup');
      final DocumentReference document = workPlanCollection.doc(user?.uid);
      final DocumentSnapshot snapshot = await document.get();

      if (!snapshot.exists) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("No work plan data is available to restore"),
            backgroundColor: redColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
        return;
      }
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;
      dataMap.forEach((key, value) {
        WorkPlanModel workPlanFromFirebase =
            WorkPlanModel.fromFirebaseJson(value as Map<String, dynamic>);
        WorkPlanModel? existingWorkPlan = workPlanBox.get(key);
        if (existingWorkPlan == null ||
            workPlanFromFirebase.toJson().toString() !=
                existingWorkPlan.toJson().toString()) {
          workPlanBox.put(key, workPlanFromFirebase);
        }
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Work plan data has been restored successfully"),
          backgroundColor: greenColor,
          showCloseIcon: true,
          closeIconColor: whiteColor,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: redColor,
          showCloseIcon: true,
          closeIconColor: whiteColor,
        ),
      );
    }
  }

  Future<void> backupDataWorkPlan(context) async {
    loadingDialogue(context: context);
    try {
      final workPlanBox = await Hive.openBox('workPlan');
      final CollectionReference workPlanCollection =
          FirebaseFirestore.instance.collection('workPlanBackup');
      final DocumentReference document = workPlanCollection.doc(user?.uid);
      final DocumentSnapshot snapshot = await document.get();
      Map<String, dynamic> existingData =
          snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};
      bool isDataExistForBackup = false;
      for (int i = 0; i < workPlanBox.length; i++) {
        String dataKey = workPlanBox.keyAt(i);
        WorkPlanModel workPlans = workPlanBox.getAt(i);
        if (!existingData.containsKey(dataKey)) {
          existingData[dataKey] = workPlans.toJson();
          isDataExistForBackup = true;
        }
      }

      if (!isDataExistForBackup) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('No new work plan data is available for backup'),
            backgroundColor: redColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
        return;
      }
      await document.set(existingData).then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Work plan data has been stored successfully"),
            backgroundColor: greenColor,
            showCloseIcon: true,
            closeIconColor: whiteColor,
          ),
        );
      });
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: redColor,
          showCloseIcon: true,
          closeIconColor: whiteColor,
        ),
      );
    }
  }
}
