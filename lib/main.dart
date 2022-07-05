import 'package:hw2/pages/driver.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  //Always needed for firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SocialApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Driver());
  }
}
