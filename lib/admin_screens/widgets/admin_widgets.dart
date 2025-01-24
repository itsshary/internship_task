import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowDialogClass {
  static void showEditDialog(
    BuildContext context,
    String userId,
    String attendanceId,
    String currentStatus,
  ) {
    TextEditingController statusController =
        TextEditingController(text: currentStatus);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Status"),
        content: TextField(
          controller: statusController,
          decoration: const InputDecoration(labelText: "Status"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String newStatus = statusController.text.trim();

              if (newStatus.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('attendance')
                    .doc(userId)
                    .collection('attendanceRecords')
                    .doc(attendanceId)
                    .update({'status': newStatus});
                Navigator.pop(context);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
