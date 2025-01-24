import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_task/firebase/upload_attendace.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/resources/utils/time_logic.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  Timestamp currentTimestamp = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    final String studentId =
        FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "Current Time: ${TimeLogic.instace.getFormattedTime(currentTimestamp)}"),
              Text(
                  "Current Date: ${TimeLogic.instace.formatTimestamp(currentTimestamp)}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final attendanceId =
                      DateTime.now().microsecondsSinceEpoch.toString();
                  await AttendanceService.instance
                      .markAttendance(studentId, attendanceId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Mark as Present",
                  style: TextStyle(fontSize: 18, color: AppColors.whitecolor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
