import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userRole;
  final String bio;
  final Timestamp? creationTime;
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.userRole,
      required this.bio,
      required this.creationTime});

  factory User.fromJson(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      userRole: data['userRole'],
      bio: data['bio'],
      creationTime: data['creationTime'],
    );
  }
  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'userRole': userRole,
        'bio': bio,
        'creationTime': creationTime,
      };
}
