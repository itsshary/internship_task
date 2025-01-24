import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_task/all_widgets/custom_button/custom_button.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/resources/utils/utilis_class.dart';

class SendLeaveRequest extends StatefulWidget {
  const SendLeaveRequest({super.key});

  @override
  State<SendLeaveRequest> createState() => _SendLeaveRequestState();
}

class _SendLeaveRequestState extends State<SendLeaveRequest> {
  final TextEditingController titlec = TextEditingController();
  final TextEditingController bodyc = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> sendApplication(String status, String aplid) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Create a new application object
      final application = {
        'aplid': aplid,
        'title': titlec.text.trim(),
        'description': bodyc.text.trim(),
        'status': status, // Default status
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(), // Optional: For sorting
      };

      // Save the application in Firestore under the user's subcollection
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(uid) // User-specific document
          .collection('userApplications')
          .doc(aplid)
          .set(application);
      ToastMessage().showToast("Application Send Successfully");

      titlec.clear();
      bodyc.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send application: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Leave Request")),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titlec,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(hintText: 'Enter Application Title...'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: bodyc,
                  maxLines: 10,
                  maxLength: 500,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(hintText: 'Enter Application Body'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Application Body';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Send",
                        color: AppColors.primaryColor,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            String aplid = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            sendApplication('pending', aplid);
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
