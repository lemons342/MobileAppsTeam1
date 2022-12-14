// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'account_model.dart';
import 'account.dart';

/** Name: Seth Frevert
* Date: 12/13/2022
* Description: A page to use to login in users
* Bugs: None that I know of
* Reflection: Beyond some design aspects that could be better, it works
*/

class Login extends StatefulWidget {
  const Login({Key? key, required this.model}) : super(key: key);
  final AccountModel model;

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
    if(widget.model.loggedIn){
      //If the user is already logged in, present a logout button
      return Account(model: widget.model);
    }
    //Otherwise present the login form 
    return Center(
        child: Form(
            key: _formKey,
            child: Column(children: [
              Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (text) =>
                    text!.isEmpty ? 'An email must be entered' : null, //Attempt to validate if something was entered
                onSaved: (text) => emailAddress = text!,
              ),),
              Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextFormField(
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
              ),),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: const Color(0xFF00FC87)),
                    child: const Text('Login')),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text('Don\'t have an account?'),
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: const Color(0xFF00FC87)),
                    child: const Text('Create Account')),
              ),
            ])));
  }

  void _login() async {
    //If the form validates 
    if (_formKey.currentState!.validate()) {
      //then save the data
      _formKey.currentState!.save();
      try {
        //Attempt to login the user
          await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        //Use a generic message for slightly more security, to prevent brute force
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-email') {
          //If the user isn't found, has the wrong password, or has an invalid email
          SnackBar snackBar = const SnackBar(content: Text('The entered information is incorrect.'), duration: Duration(milliseconds: 2000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'user-disabled') { //If the account is disabled
          SnackBar snackBar = const SnackBar(content: Text('User is disabled.'), duration: Duration(milliseconds: 2000),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  void _register(){
    Navigator.of(context).pushNamed('/register');
  }
}
