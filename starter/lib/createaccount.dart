// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'account_model.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key, required this.model}) : super(key: key);
  final AccountModel model;

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //variables to store form information
  late String emailAddress;
  late String confirmedPassword;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //If a logged user got here send them back
    if(widget.model.loggedIn){
      Navigator.of(context).pop();
    }
    //Otherwise present the form
    return Scaffold(
      appBar: AppBar(centerTitle: false,
          backgroundColor: Colors.black,
          title: const Text('FreeTime'), //Make this look better
          actions: [
            SizedBox( //title bar(top of screen)
              width: 200,
              child: Image.asset(
                'assets/bbbs_logo.png',
              ),
            ),
            // const IconButton(
            //   onPressed: null,
            //   icon: Icon(Icons.exit_to_app),
            // ), //button to redirect user to webpage (keep for now)
            const Icon(Icons
                .exit_to_app) //Tried to change to IconButton but was invisible
          ],
          toolbarHeight: 70,),
      body: Center(
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
                  validator: (text) => _validatePassword(password: text!) //Attempt to validate the password
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
                      _validateConfirmPassword(confirmPassword: text!) //Attempt to validate the confirm password
                          ? 'Passwords must match'
                          : null,
                ),
                ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: const Color(0xFF00FC87)),
                    child: const Text('Create Account'))
              ]))),
    );
  }

  bool _validatePassword({required String password}) {
    //Used so the passwords entered can be compared later
    confirmedPassword = password;
    if (password.isEmpty) {
      return true;
    }
    return false;
  }

  bool _validateConfirmPassword({required String confirmPassword}) {
    if (confirmPassword.isEmpty) { //If no value was entered
      return true; //then stop here and tell the user
    }
    if (confirmPassword != confirmedPassword) { //If the passwords don't match
      return true; //then stop here and tell the user
    }
    return false;
  }

  void _createAccount() async {
    //If the form validates 
    if (_formKey.currentState!.validate()) {
      //then save the data
      _formKey.currentState!.save();
      try {
        //Attempt to create a new account
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: confirmedPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //If firebase thinks the password is too weak
          SnackBar snackBar = const SnackBar(content: Text('The password provided is too weak.'), duration: Duration(milliseconds: 2000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'email-already-in-use') {
          //If the email is already connected to another account
          SnackBar snackBar = const SnackBar(content: Text('The account already exists for that email.'), duration: Duration(milliseconds: 2000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } 
    }
  }
}
