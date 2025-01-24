import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_task/all_widgets/custom_button/custom_button.dart';
import 'package:internship_task/resources/app_text_style/app_text_style.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/routes/routes_name.dart';
import 'package:internship_task/user_screens/auth_screen/user_signup_screen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});
  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool obsecure = true;
  bool isLoading = false;
  String email = 'admin@gmail.com';
  String password = '123456';
  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (emailController.text.toString() == email &&
            passwordController.text.toString() == password) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routesname.adminhomescreen,
            (route) => false,
          );
        } else {
          await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            Routesname.bottomnavigation,
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password.';
        } else {
          errorMessage = e.message ?? 'Login failed. Please try again.';
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back",
                style: AppTextStyle.commonstyle
                    .copyWith(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage: AssetImage("assets/images/eztech.png"),
                  backgroundColor: Colors.blue,
                ),
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: AppColors.grey,
                  hintText: 'Enter Email',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: obsecure,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                    icon: Icon(
                      obsecure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  fillColor: AppColors.grey,
                  hintText: 'Enter Password',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: 'Login',
                      color: AppColors.primaryColor,
                      onTap: loginUser,
                    ),
              CustomButton(
                text: 'Signup',
                color: AppColors.blackcolor,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserSignupScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
