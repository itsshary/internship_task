import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_task/admin_screens/view_records/view_records.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<String> tasks = [
    "View Records",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            // Flatten data for all UIDs and their records
            final List<Map<String, dynamic>> userData = snapshot.data!.docs
                .map((doc) => {
                      'uid': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    })
                .toList();

            return GridView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: tasks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 8 / 9,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (tasks[index] == "View Records") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewRecords(
                                    userdata: userData,
                                  )));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: AppColors.primaryColor.withAlpha(200),
                    ),
                    child: Center(
                      child: Text(
                        tasks[index],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
