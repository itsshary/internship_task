class AttendanceModel {
  final String id;
  final String status;
  final String time;
  final String date;
  final String attendanceId;

  AttendanceModel(
      {required this.id,
      required this.status,
      required this.time,
      required this.date,
      required this.attendanceId});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'time': time,
      'date': date,
      'attendanceId': attendanceId,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
        id: map['id'],
        status: map['status'],
        time: map['time'],
        date: map['date'],
        attendanceId: map['attendanceId']);
  }
}
