import 'package:flutter/material.dart';
import 'package:internship_task/admin_screens/admin_home_screen/admin_home_screen.dart';
import 'package:internship_task/routes/routes_name.dart';
import 'package:internship_task/services/splash_screen/splash_screen.dart';
import 'package:internship_task/user_screens/auth_screen/user_login_screen.dart';
import 'package:internship_task/user_screens/auth_screen/user_signup_screen.dart';
import 'package:internship_task/user_screens/bottom_screen/bottom_screen.dart';
import 'package:internship_task/user_screens/mark_attendance/mark_attendance.dart';
import 'package:internship_task/user_screens/profile_screen/profile_screen.dart';
import 'package:internship_task/user_screens/send_leave_request/check_leave.dart';
import 'package:internship_task/user_screens/send_leave_request/send_leave_request.dart';
import 'package:internship_task/user_screens/user_home_screen/user_home_screen.dart';
import 'package:internship_task/user_screens/view_attendance/view_attendance.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routesname.splashscreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case Routesname.loginscreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserLoginScreen());
      case Routesname.signupscreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserSignupScreen());
      case Routesname.userhomescreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserHomeScreen());
      case Routesname.marksattendance:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MarkAttendance());
      case Routesname.profilescreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());
      case Routesname.bottomnavigation:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CustomBottomBar());
      case Routesname.marksleave:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SendLeaveRequest());
      case Routesname.checkleave:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CheckLeave());
      case Routesname.viewattendance:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewAttendance());

      case Routesname.adminhomescreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AdminHomeScreen());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Scaffold(
                  body: Center(
                    child: Text("No Routes Defined"),
                  ),
                ));
    }
  }
}
