import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    this.createdAt,
  });

  // Convert a UserModel object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'createdAt': createdAt,
    };
  }

  // Create a UserModel object from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      image: map['image'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
