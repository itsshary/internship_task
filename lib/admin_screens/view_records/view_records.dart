import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/admin_screens/Check%20Attendance/check_attendace_admin.dart';
import 'package:internship_task/admin_screens/csr_report_screen/csr_report_screen.dart';
import 'package:internship_task/admin_screens/leave_approve_screen/leave_approve_screen.dart';
import 'package:internship_task/firebase/delete_user_adminside.dart';
import 'package:internship_task/resources/app_text_style/app_text_style.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';

// ignore: must_be_immutable
class ViewRecords extends StatefulWidget {
  List<Map<String, dynamic>> userdata;
  ViewRecords({super.key, required this.userdata});

  @override
  State<ViewRecords> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecords> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "All User's",
          style: AppTextStyle.commonstyle.copyWith(
            color: AppColors.whitecolor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView.builder(
        itemCount: widget.userdata.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaveApproveScreen(
                                    userdata: widget.userdata,
                                    index: index,
                                  )));
                    },
                    child: Text("Check Leaves")),
                ListTile(
                    leading: InkWell(
                        onTap: () async {
                          try {
                            await DeleteUserAdminside.instance
                                .deleteUser(widget.userdata[index]['uid']);
                            await _auth.currentUser?.delete();
                            setState(() {
                              widget.userdata.removeAt(index);
                            });
                          } catch (e) {
                            // Handle error (optional)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete user: $e'),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    title: Text(widget.userdata[index]['name'].toString()),
                    subtitle: Text(widget.userdata[index]['email'].toString()),
                    trailing: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckAttendaceAdmin(
                                        index: index,
                                        userdata: widget.userdata,
                                      )));
                        },
                        child: Text(
                          "Check Attendance",
                          style:
                              AppTextStyle.commonstyle.copyWith(fontSize: 14),
                        ))),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CsrReportScreen()));
        },
        label: Text("CSR Report"),
      ),
    ));
  }
}
