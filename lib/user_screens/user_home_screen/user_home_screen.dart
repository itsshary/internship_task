import 'package:flutter/material.dart';
import 'package:internship_task/all_widgets/custom_button/custom_button.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/routes/routes_name.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.0,
          children: [
            CustomButton(
                text: 'Mark Attendance',
                color: AppColors.primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, Routesname.marksattendance);
                }),
            CustomButton(
                text: 'View Attendance',
                color: AppColors.primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, Routesname.viewattendance);
                }),
            CustomButton(
                text: 'Mark Leave',
                color: AppColors.primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, Routesname.marksleave);
                }),
          ],
        ),
      ),
    );
  }
}
