import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/models/user_model.dart';
import 'package:internship_task/resources/utils/utilis_class.dart';
import 'package:internship_task/routes/routes_name.dart';

class Authservices {
  static Authservices instace = Authservices();
  final _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> signUpUser(String name, String email, String password,
      String image, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        name: name,
        email: email,
        image: "",
        createdAt: DateTime.now(),
      );

      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .set(newUser.toMap());
      ToastMessage().showToast('Account created successfully');
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routesname.bottomnavigation,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }
}
