import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:hw2/pages/home.dart';
import 'package:hw2/model/user.dart';
import 'package:hw2/model/post.dart';
import 'package:flutter/material.dart';
import 'package:hw2/services/firestore_service.dart';
import 'package:hw2/widgets/loading.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.observedUser}) : super(key: key);

  final User observedUser;

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final FirestoreService _db = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "${widget.observedUser.firstName} ${widget.observedUser.lastName}")),
        body: Column(children: [
          Container(child: const Text("Biography:")),
          Container(child: Text(widget.observedUser.bio)),
          Container(child: const Text("")), //empty line
          Container(child: const Text("Posts: ")),
          StreamBuilder<List<Post>>(
            stream: _db.posts,
            builder:
                (BuildContext context, AsyncSnapshot<List<Post>> snapshots) {
              if (snapshots.hasError) {
                return Center(child: Text(snapshots.error.toString()));
              } else if (snapshots.hasData) {
                var posts = snapshots.data!;
                var filterpost = [];
                for (var element in posts) {
                  if (element.owner == widget.observedUser.id) {
                    filterpost.add(element);
                  }
                }

                return filterpost.isEmpty
                    ? const Center(child: Text("There are no posts."))
                    : Expanded(
                        child: ListView.builder(
                            itemCount: filterpost.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                                    title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      Text(filterpost[index].message),
                                      const SizedBox(height: 10),
                                      Text(filterpost[index]
                                          .created
                                          .toDate()
                                          .toString())
                                    ]))));
              }
              return const Loading();
            },
          )
        ]));
  }
}
