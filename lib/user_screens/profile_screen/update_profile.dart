import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_task/all_widgets/custom_button/custom_button.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/resources/utils/utilis_class.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({
    super.key,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _existingImageUrl;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          _existingImageUrl = data['image'] ?? '';
          setState(() {}); // Update the UI
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // ImageKit upload function (same as before)
  Future<String?> uploadFileToImageKit(File file, String fileName) async {
    const String imageKitUrl = "";
    const String publicApiKey = ""; // Replace with your key.

    try {
      final request = http.MultipartRequest("POST", Uri.parse(imageKitUrl));
      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/uploads";
      request.fields['useUniqueFileName'] = "true";
      request.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode("$publicApiKey:"))}';

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        return decodedResponse['url'];
      } else {
        throw Exception("Failed to upload file: ${response.reasonPhrase}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("ImageKit Upload Error: $e");
      }
      return null;
    }
  }

  // Select image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Update Firestore profile
  Future<void> _updateProfile() async {
    try {
      // Upload the image if selected
      if (_selectedImage != null) {
        _uploadedImageUrl =
            await uploadFileToImageKit(_selectedImage!, "profile_image");
      }

      // Update Firestore
      await _firestore.collection('users').doc(uid).update(
        {
          'image': _uploadedImageUrl ?? _existingImageUrl ?? "",
        },
      );

      ToastMessage().showToast('Profile updated!');
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 10.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.primaryColor),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 70,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_existingImageUrl != null &&
                              _existingImageUrl!.isNotEmpty
                          ? NetworkImage(_existingImageUrl!)
                          : null),
                  child: (_selectedImage == null &&
                          (_existingImageUrl == null ||
                              _existingImageUrl!.isEmpty))
                      ? const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 35,
                        )
                      : null,
                ),
              ),
              CustomButton(
                text: "Update Profile",
                color: AppColors.primaryColor,
                onTap: _updateProfile,
              )
            ],
          ),
        ),
      ),
    );
  }
}
