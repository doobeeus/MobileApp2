import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(
      {required this.id,
      required this.message,
      required this.type,
      required this.owner,
      required this.created});

  factory Post.fromJson(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      message: data['message'],
      type: data['type'] ?? 0,
      owner: data['owner'],
      created: data['created'],
    );
  }
  Map<String, dynamic> toJson() => {
        'message': message,
        'type': type,
        'owner': owner,
        'created': created,
      };

  final String id;
  final String message;
  int type;
  final String owner;
  final Timestamp created;
}
