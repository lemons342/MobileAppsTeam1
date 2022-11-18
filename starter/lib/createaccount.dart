// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late String emailAddress;
  late String confirmedPassword;

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
                validator: (text) => _validatePassword(password: text!)
                    ? 'A password must be entered'
                    : null,
                onSaved: (text) => confirmedPassword = text!,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                validator: (text) =>
                    _validateConfirmPassword(confirmPassword: text!)
                        ? 'Passwords must match'
                        : null,
              ),
              ElevatedButton(
                  onPressed: _createAccount,
                  child: const Text('Create Account'))
            ])));
  }

  bool _validatePassword({required String password}) {
    confirmedPassword = password;
    if (password.isEmpty) {
      return true;
    }
    return false;
  }

  bool _validateConfirmPassword({required String confirmPassword}) {
    if (confirmPassword.isEmpty) {
      return true;
    }
    if (confirmPassword != confirmedPassword) {
      return true;
    }
    return false;
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: confirmedPassword,
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
