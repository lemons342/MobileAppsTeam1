// ignore_for_file: non_constant_identifier_names, slash_for_doc_comments

import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart'
  hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/**
 * Name: Seth Frevert
 * Date: 12/13/2022
 * Description: Stores the current user and possesses functionality related to firestore auth
 * Bugs: None that I know of
 * Reflection:
 */

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }
  
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        //If user has a value they are logged in
        _loggedIn = true;
      } else {
        //If user doesn't have a value they are logged out
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  String GetUserEmail(){
    if(_loggedIn){
      //Return the email if the user is logged in
      return FirebaseAuth.instance.currentUser!.email!;
    }
    //Otherwise return nothing
    return ' ';
  }

  void Logout(){
    //Logout the user
    FirebaseAuth.instance.signOut();
  }

  
}