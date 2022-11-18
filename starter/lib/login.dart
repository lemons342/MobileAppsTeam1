// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String emailAddress;
  late String password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (text) =>
                    text!.isEmpty ? 'An email must be entered' : null,
                onSaved: (text) => emailAddress = text!,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (text) => text!.isEmpty
                    ? 'A password must be entered'
                    : null,
                onSaved: (text) => password = text!,
              ),
              ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'))
            ])));
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          SnackBar snackBar = const SnackBar(content: Text('The password provided is too weak.'), duration: Duration(milliseconds: 20000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'email-already-in-use') {
          SnackBar snackBar = const SnackBar(content: Text('The account already exists for that email.'), duration: Duration(milliseconds: 20000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        //print(e);
      }
    }
  }
}
