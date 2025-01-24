import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/firebase_options.dart';
import 'package:internship_task/routes/routes.dart';
import 'package:internship_task/routes/routes_name.dart';
import 'package:internship_task/user_screens/auth_screen/user_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routesname.splashscreen,
      onGenerateRoute: Routes.generateRoutes,
      home: UserLoginScreen(),
    );
  }
}
