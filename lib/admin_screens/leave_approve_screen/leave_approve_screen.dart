import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';

class LeaveApproveScreen extends StatefulWidget {
  List<Map<String, dynamic>> userdata;
  int index;
  LeaveApproveScreen({
    super.key,
    required this.userdata,
    required this.index,
  });

  @override
  State<LeaveApproveScreen> createState() => _LeaveApproveScreenState();
}

class _LeaveApproveScreenState extends State<LeaveApproveScreen> {
  int totalLeves = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Leave Approval Screen'),
          backgroundColor: AppColors.primaryColor),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .doc(widget.userdata[widget.index]['uid'])
            .collection("userApplications")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No leave applications found.'),
            );
          }

          var applications = snapshot.data!.docs;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Leaves: ${snapshot.data!.docs.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title: ${applications[index]['title'] ?? 'N/A'}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Body: ${applications[index]['description'] ?? 'N/A'}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Application Time: ${applications[index]['createdAt'] != null ? (applications[index]['createdAt'] as Timestamp).toDate().toString() : 'N/A'}',
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Current status
                                Text(
                                  'Status: ${applications[index]['status'] ?? 'Pending'}',
                                  style: const TextStyle(fontSize: 16),
                                ),

                                DropdownButton<String>(
                                  value: applications[index]['status'] ??
                                      'pending',
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'pending',
                                        child: Text('Pending')),
                                    DropdownMenuItem(
                                        value: 'approved',
                                        child: Text('Approved')),
                                    DropdownMenuItem(
                                        value: 'rejected',
                                        child: Text('Rejected')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      _updateStatus(applications[index]['uid'],
                                          applications[index]['aplid'], value);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateStatus(
      String uid, String applicationId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(widget.userdata[widget.index]['uid'])
          .collection('userApplications')
          .doc(applicationId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }
}
