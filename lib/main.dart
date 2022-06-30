import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hw2/pages/authentication.dart';

import '../widgets/loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder(
          initialData: _initFirebase,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("An error has occured."),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            return Authentication();
          },
        ),
      ),
    );
  }
}
