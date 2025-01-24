class UserModel {
  final String title;
  final String description;
  final String status;
  final String uid;

  UserModel({
    required this.title,
    required this.description,
    required this.status,
    required this.uid,
  });

  // Convert a UserModel object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'uid': uid,
    };
  }

  // Create a UserModel object from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        title: map['title'],
        description: map['description'],
        status: map['status'],
        uid: map['uid']);
  }
}
