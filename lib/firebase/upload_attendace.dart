import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_task/models/upload_attendance_model.dart';
import 'package:internship_task/resources/utils/time_logic.dart';
import 'package:internship_task/resources/utils/utilis_class.dart';

class AttendanceService {
  static AttendanceService instance = AttendanceService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(String studentId, String id) async {
    try {
      // Get current time and date
      Timestamp currentTimestamp = Timestamp.now();
      String currentDate = TimeLogic.instace.formatTimestamp(currentTimestamp);

      // Reference to the student's attendance sub-collection
      CollectionReference attendanceRecords = _firestore
          .collection('attendance')
          .doc(studentId)
          .collection('attendanceRecords');

      // Check if attendance is already marked for today
      QuerySnapshot querySnapshot =
          await attendanceRecords.where('date', isEqualTo: currentDate).get();

      if (querySnapshot.docs.isNotEmpty) {
        ToastMessage().showToast("Attendance already marked for today!");
        return;
      }

      // Create an instance of AttendanceModel
      AttendanceModel attendance = AttendanceModel(
        id: studentId,
        status: 'Present',
        time: TimeLogic.instace.getFormattedTime(currentTimestamp),
        date: currentDate,
        attendanceId: id,
      );

      // Add a new document to the attendanceRecords sub-collection
      await attendanceRecords.doc(id).set(attendance.toMap());

      ToastMessage().showToast("Attendance Uploaded Successfully");
    } catch (e) {
      ToastMessage().showToast("Error: $e");
    }
  }
}
