import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _email,
                decoration: inputStyling("Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty";
                  }
                  if (!value.contains('@')) {
                    return "Email is in wrong format";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _password,
                decoration: inputStyling("Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if (value.length < 7) {
                    return "Password is too short.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstName,
                decoration: inputStyling("First Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "First name cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastName,
                decoration: inputStyling("Last Name"),
                validator: (value) {
                  if (value == null) {
                    return "Last Name cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bio,
                decoration: inputStyling("Biography"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Biography cannot be empty";
                  }
                  return null;
                },
              ),
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                      register();
                    });
                  },
                  child: Text("REGISTER")),
              OutlinedButton(onPressed: () {}, child: Text("FORGOT PASSWORD")),
            ]));
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential registerResponse =
            await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);

        _db
            .collection("users")
            .doc(registerResponse.user!.uid)
            .set({
              "firstName": _firstName.text,
              "lastName": _lastName.text,
              "userRole": "customer",
              "bio": _bio.text,
              "creationTime": Timestamp.now(),
            })
            .then((value) => snackBar(context, "User registered successfully."))
            .catchError((error) => snackBar(context, "FAILED. $error"));

        registerResponse.user!.sendEmailVerification();
        setState(() {
          snackBar(context, "User registered successfully");
          loading = false;
        });
      } catch (e) {
        setState(() {
          snackBar(context, "User didn't register properly");
          loading = false;
        });
      }
    }
  }
}
