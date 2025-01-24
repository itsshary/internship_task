import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeLogic {
  static TimeLogic instace = TimeLogic();
  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();

    String formattedDate = DateFormat('dd, MMM, yyyy').format(date);

    return formattedDate;
  }

  String getFormattedTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }
}
