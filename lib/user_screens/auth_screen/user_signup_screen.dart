import 'package:flutter/material.dart';
import 'package:internship_task/all_widgets/custom_button/custom_button.dart';
import 'package:internship_task/firebase/auth_services.dart';
import 'package:internship_task/resources/app_text_style/app_text_style.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});
  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obsecure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text("Welcome For Creating \nNew Account",
                      style: AppTextStyle.commonstyle.copyWith(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
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
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    fillColor: AppColors.grey,
                    hintText: 'Enter Your Name...',
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Name';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: AppColors.grey,
                    hintText: 'Enter Email',
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
                        icon: Icon(obsecure == false
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    fillColor: AppColors.grey,
                    hintText: 'Enter Password',
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Signup',
                        color: AppColors.primaryColor,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await Authservices.instace.signUpUser(
                                nameController.text.toString(),
                                emailController.text.toString(),
                                passwordController.text.toString(),
                                "",
                                context);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
