import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Attendance"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('attendance')
            .doc(uid)
            .collection('attendanceRecords') // Sub-collection for attendance
            .orderBy('date', descending: true) // Order by date (latest first)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading attendance records."),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No attendance records found."),
            );
          }

          // Extract the list of attendance records
          final attendanceRecords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              final record =
                  attendanceRecords[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text("Attendance:  ${record['status']}"),
                  subtitle: Text(
                      "Time: ${record['time']} \n: ${"Date: ${record['date']}"}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
