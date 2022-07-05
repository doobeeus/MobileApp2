import 'package:hw2/model/post.dart';
import 'package:hw2/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();
  final TextEditingController _message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _message,
            minLines: 5,
            maxLines: 5,
          ),
          OutlinedButton(
              onPressed: _submitPost, child: const Text("Submit Post"))
        ],
      ),
    );
  }

  void _submitPost() {
    _db.addPost({
      "message": _message.text,
      "owner": _auth.currentUser!.uid
    }).then((value) => Navigator.of(context).pop());
  }
}