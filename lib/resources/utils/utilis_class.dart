import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';

class ToastMessage {
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.blackcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
