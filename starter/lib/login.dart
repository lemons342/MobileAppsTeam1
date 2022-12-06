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
  //variables to store form information
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
                    text!.isEmpty ? 'An email must be entered' : null, //Attempt to validate if something was entered
                onSaved: (text) => emailAddress = text!,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (text) => text!.isEmpty //Attempt to validate if something was entered
                    ? 'A password must be entered'
                    : null,
                onSaved: (text) => password = text!,
              ),
              ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login')),
              ElevatedButton(
                  onPressed: _register,
                  child: const Text('Create Account')),
            ])));
  }

  void _login() async {
    //If the form validates 
    if (_formKey.currentState!.validate()) {
      //then save the data
      _formKey.currentState!.save();
      try {
        //Attempt to login the user
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        //Use a generic message for slightly more security
        if (e.code == 'user-not-found') {
          //If the user isn't found
          SnackBar snackBar = const SnackBar(content: Text('The entered information is incorrect.'), duration: Duration(milliseconds: 20000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'wrong-password') {
          //If the wrong password is used
          SnackBar snackBar = const SnackBar(content: Text('The entered information is incorrect.'), duration: Duration(milliseconds: 20000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  void _register(){
    Navigator.of(context).pushNamed('/register');
  }
}
