import 'package:flutter/material.dart';
import 'package:hw2/forms/loginform.dart';
import 'package:hw2/forms/registerform.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Authentication"),
        ),
        body: const RegisterForm());
  }
}
