import 'package:flutter/material.dart';
import 'package:internship_task/services/splash_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashscreen = SplashServices();

  void initState() {
    super.initState();
    splashscreen.islogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage: AssetImage("assets/images/eztech.png"),
                  backgroundColor: Colors.blue,
                ),
              ),
              Text(
                'Internship Task Ezitech',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
