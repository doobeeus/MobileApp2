import 'package:hw2/forms/postform.dart';
import 'package:hw2/model/post.dart';
import 'package:hw2/pages/authentication.dart';
import 'package:hw2/pages/profile.dart';
import 'package:hw2/services/firestore_service.dart';
import 'package:hw2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:hw2/pages/conversations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ConversationsPage()));
            },
            icon: const Icon(Icons.message),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  logout();
                });
              },
              icon: const Icon(Icons.logout))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: _showPostField,
          child: const Icon(Icons.post_add),
        ),
        body: StreamBuilder<List<Post>>(
          stream: _fs.posts,
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshots) {
            if (snapshots.hasError) {
              return Center(child: Text(snapshots.error.toString()));
            } else if (snapshots.hasData) {
              var posts = snapshots.data!;

              return posts.isEmpty
                  ? const Center(child: Text("There are no posts."))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                              title: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile(
                                                observedUser:
                                                    FirestoreService.userMap[
                                                        posts[index].owner]!)));
                                  },
                                  child: Text(FirestoreService
                                      .userMap[posts[index].owner]!.firstName)),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(posts[index].message),
                                    const SizedBox(height: 10),
                                    Text(posts[index]
                                        .created
                                        .toDate()
                                        .toString())
                                  ])));
            }
            return const Loading();
          },
        ));
  }

  //Displays a ModalPopUp that shows a text field and submit button for Post
  void logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Authentication()),
      ModalRoute.withName('/'),
    );
  }

  void _showPostField() {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return const PostForm();
        });
  }
}
