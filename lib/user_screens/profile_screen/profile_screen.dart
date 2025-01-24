import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/routes/routes_name.dart';
import 'package:internship_task/user_screens/auth_screen/user_login_screen.dart';
import 'package:internship_task/user_screens/profile_screen/update_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String address = "Loading address...";

  @override
  Widget build(BuildContext context) {
    final String uid = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          final userData = snapshot.data!;
          final String firstName = userData['name'] ?? '';

          final String email = userData['email'] ?? '';

          final String imageUrl = userData['image'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : const NetworkImage(
                          "https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/avatar-512.png"),
                ),
                const SizedBox(height: 16),
                Text(
                  "$firstName ",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                        ),
                        title: const Text("Update Profile"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfile()));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                        ),
                        title: const Text("Leave Status"),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routesname.checkleave,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: AppColors.primaryColor,
                        ),
                        title: const Text("Log Out"),
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserLoginScreen()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
