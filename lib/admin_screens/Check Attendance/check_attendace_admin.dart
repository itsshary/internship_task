import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/admin_screens/widgets/admin_widgets.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';

// ignore: must_be_immutable
class CheckAttendaceAdmin extends StatefulWidget {
  final List<Map<String, dynamic>> userdata;
  final int index;

  CheckAttendaceAdmin({super.key, required this.userdata, required this.index});

  @override
  State<CheckAttendaceAdmin> createState() => _CheckAttendaceAdminState();
}

class _CheckAttendaceAdminState extends State<CheckAttendaceAdmin> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Check Attendance",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 40,
            ),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .doc(widget.userdata[widget.index]['uid'])
            .collection('attendanceRecords')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          // Filter attendance records based on the selected date range
          var attendancedata = snapshot.data!.docs.where((doc) {
            if (_fromDate != null && _toDate != null) {
              DateTime recordDate;

              // Check if the date field is a Timestamp or String
              if (doc['date'] is Timestamp) {
                recordDate = (doc['date'] as Timestamp).toDate();
              } else if (doc['date'] is String) {
                try {
                  recordDate = _parseDate(doc['date']); // Use custom parser
                } catch (e) {
                  return false; // Invalid date format
                }
              } else {
                return false; // Invalid data type for the date field
              }

              return recordDate
                      .isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
                  recordDate.isBefore(_toDate!.add(const Duration(days: 1)));
            }
            return true; // Show all records if no date range is selected
          }).toList();

          if (attendancedata.isEmpty) {
            return const Center(
                child: Text("No data found for the selected date range"));
          }
          int presentCount = attendancedata
              .where((record) => record['status'] == 'Present')
              .length;
          int absentCount = attendancedata
              .where((record) => record['status'] == 'Absent')
              .length;
          int totalAttendance = attendancedata.length;
          String grade;
          if (totalAttendance == 4) {
            grade = 'A';
          } else if (totalAttendance >= 3) {
            grade = 'B';
          } else if (totalAttendance >= 2) {
            grade = 'C';
          } else {
            grade = 'D';
          }
          return Column(
            children: [
              // Display counts at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 300,
                          height: 150,
                          color: Colors.amber.shade100,
                          child: Column(
                            children: [
                              Text(
                                'Total Attendance: $totalAttendance        Grade: $grade',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text("Total Presents: $presentCount",
                                  style: const TextStyle(fontSize: 16)),
                              Text("Total Absent: $absentCount",
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Attendance List
              Expanded(
                child: ListView.builder(
                  itemCount: attendancedata.length,
                  itemBuilder: (context, index) {
                    DateTime recordDate;
                    if (attendancedata[index]['date'] is Timestamp) {
                      recordDate =
                          (attendancedata[index]['date'] as Timestamp).toDate();
                    } else if (attendancedata[index]['date'] is String) {
                      try {
                        recordDate = _parseDate(attendancedata[index]['date']);
                      } catch (e) {
                        recordDate = DateTime.now(); // Default fallback
                      }
                    } else {
                      recordDate = DateTime.now(); // Default fallback
                    }

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(attendancedata[index]['status']),
                        trailing: InkWell(
                          onTap: () {
                            ShowDialogClass.showEditDialog(
                              context,
                              widget.userdata[widget.index]['uid'],
                              attendancedata[index]['attendanceId'],
                              attendancedata[index]['status'],
                            );
                          },
                          child:
                              Icon(Icons.edit, color: AppColors.primaryColor),
                        ),
                        leading: InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('attendance')
                                  .doc(widget.userdata[widget.index]['uid'])
                                  .collection('attendanceRecords')
                                  .doc(attendancedata[index]['attendanceId'])
                                  .delete();
                              setState(() {});
                            },
                            child: Icon(Icons.delete, color: Colors.red)),
                        subtitle: Text(
                          'Date: ${recordDate.toLocal().day}:'
                          '${recordDate.toLocal().month}:'
                          '${recordDate.toLocal().year}'
                          '   Time: ${attendancedata[index]['time']}',
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

  // Function to parse the custom date format (e.g., 23, Jan, 2025)
  DateTime _parseDate(String dateStr) {
    final months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    // Example format: 23, Jan, 2025
    final parts = dateStr.split(', ');
    if (parts.length != 3) {
      throw FormatException('Invalid date format');
    }

    final day = int.parse(parts[0]);
    final monthStr = parts[1];
    final year = int.parse(parts[2]);

    final month = months[monthStr];
    if (month == null) {
      throw FormatException('Invalid month name');
    }

    return DateTime(year, month, day);
  }

  // Function to select date range
  Future<void> _selectDateRange() async {
    DateTimeRange? selectedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );

    if (selectedDateRange != null) {
      setState(() {
        _fromDate = selectedDateRange.start;
        _toDate = selectedDateRange.end;
      });
    }
  }
}
