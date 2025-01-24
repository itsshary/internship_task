import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CsrReportScreen extends StatefulWidget {
  const CsrReportScreen({super.key});

  @override
  State<CsrReportScreen> createState() => _CsrReportScreenState();
}

class _CsrReportScreenState extends State<CsrReportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<AttendanceRecord> _attendanceRecords = [];
  bool _isLoading = false;

  final DateFormat _dateFormat = DateFormat('dd, MMM, yyyy');

  // Improved date picker method
  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  // Robust attendance records fetching
  Future<void> _fetchAttendanceRecords() async {
    if (_startDate == null || _endDate == null) {
      _showErrorSnackBar("Please select a date range.");
      return;
    }

    setState(() {
      _isLoading = true;
      _attendanceRecords = [];
    });

    try {
      // Fetch all attendance documents
      QuerySnapshot attendanceSnapshot =
          await FirebaseFirestore.instance.collection('attendance').get();

      List<AttendanceRecord> fetchedRecords = [];

      // Iterate through each student's attendance document
      for (var studentDoc in attendanceSnapshot.docs) {
        // Get the attendanceRecords sub-collection for this student
        QuerySnapshot recordsSnapshot = await studentDoc.reference
            .collection('attendanceRecords')
            .where('date',
                isGreaterThanOrEqualTo: _dateFormat.format(_startDate!))
            .where('date', isLessThanOrEqualTo: _dateFormat.format(_endDate!))
            .get();

        // Convert records to AttendanceRecord objects
        for (var recordDoc in recordsSnapshot.docs) {
          final data = recordDoc.data() as Map<String, dynamic>;
          fetchedRecords.add(AttendanceRecord.fromMap(data));
        }
      }

      // Sort records by date
      fetchedRecords.sort((a, b) =>
          _dateFormat.parse(b.date).compareTo(_dateFormat.parse(a.date)));

      setState(() {
        _attendanceRecords = fetchedRecords;
        _isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar("Error fetching records: ${e.toString()}");
      setState(() => _isLoading = false);
    }
  }

  // Error handling method
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Range Picker
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text(_startDate != null && _endDate != null
                  ? 'Date Range: ${_dateFormat.format(_startDate!)} - ${_dateFormat.format(_endDate!)}'
                  : 'Select Date Range'),
            ),
            const SizedBox(height: 16),

            // Fetch Report Button
            ElevatedButton(
              onPressed: _fetchAttendanceRecords,
              child: const Text("Fetch Report"),
            ),

            const SizedBox(height: 16),

            // Loading or Records Display
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: _buildAttendanceList(),
                  ),
          ],
        ),
      ),
    );
  }

  // Separate method to build attendance list
  Widget _buildAttendanceList() {
    if (_attendanceRecords.isEmpty) {
      return const Center(child: Text("No records found."));
    }

    return ListView.builder(
      itemCount: _attendanceRecords.length,
      itemBuilder: (context, index) {
        final record = _attendanceRecords[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text("Student ID: ${record.id}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date: ${record.date}"),
                Text("Time: ${record.time}"),
                Text("Status: ${record.status}"),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Attendance Record Model
class AttendanceRecord {
  final String id;
  final String status;
  final String time;
  final String date;
  final String attendanceId;

  AttendanceRecord({
    required this.id,
    required this.status,
    required this.time,
    required this.date,
    required this.attendanceId,
  });

  // Factory constructor to create an AttendanceRecord from a map
  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] ?? '',
      status: map['status'] ?? 'N/A',
      time: map['time'] ?? 'N/A',
      date: map['date'] ?? 'N/A',
      attendanceId: map['attendanceId'] ?? '',
    );
  }
}
