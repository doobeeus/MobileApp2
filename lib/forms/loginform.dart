import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hw2/pages/home.dart';
import '../style/style.dart';
import '../widgets/loading.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: inputStyling("Email"),
                    validator: (value) {
                      if (value == null) {
                        return "Email cannot be empty";
                      }
                      if (!value.contains('@')) {
                        return "Email is in wrong format";
                      }
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
                    },
                  ),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          login();
                        });
                      },
                      child: Text("Login")),
                  OutlinedButton(
                      onPressed: () {
                        forgot();
                      },
                      child: Text("Forgot Password?")),
                ]));
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential loginResponse = await _auth.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);

        if (loginResponse.user!.emailVerified) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        } else {
          loginResponse.user!.sendEmailVerification();
        }
        setState(() {
          snackBar(context, "User logged in but email is not verified.");
          loginResponse.user!.sendEmailVerification();
          loading = false;
        });
      } catch (e) {
        setState(() {
          snackBar(context, e.toString());
          loading = false;
        });
      }
    }
  }

  Future<void> forgot() async {
    if (_email.text.isNotEmpty) {
      _auth.sendPasswordResetEmail(email: _email.text);
      snackBar(context, "Password reset sent to email.");
    }
  }
}
