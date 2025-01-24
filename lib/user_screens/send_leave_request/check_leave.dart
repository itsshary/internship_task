import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckLeave extends StatefulWidget {
  const CheckLeave({super.key});

  @override
  State<CheckLeave> createState() => _CheckLeaveState();
}

class _CheckLeaveState extends State<CheckLeave> {
  final String uid = FirebaseAuth
      .instance.currentUser!.uid; // Replace this with the logged-in user's UID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Applications'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .doc(uid) // User-specific document
            .collection('userApplications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Error fetching leave applications'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No leave applications found.'));
          }

          final applications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              final title = application['title'] ?? 'No Title';
              final status = application['status'] ?? 'Unknown';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Status: $status'),
                  trailing: _getStatusIcon(status),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to get a status-specific icon
  Widget _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'rejected':
        return const Icon(Icons.cancel, color: Colors.red);
      case 'pending':
      default:
        return const Icon(Icons.hourglass_bottom, color: Colors.amber);
    }
  }
}
