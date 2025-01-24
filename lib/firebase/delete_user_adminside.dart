import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_task/resources/utils/utilis_class.dart';

class DeleteUserAdminside {
  static DeleteUserAdminside instance = DeleteUserAdminside();
  Future<void> deleteUser(String uid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.collection('users').doc(uid).delete();

      ToastMessage().showToast("User Deleted Successfully");
    } catch (e) {
      rethrow; // Rethrow to handle errors in the calling function
    }
  }
}
