import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Quick make of a way to have access to if the user is signed in or not across app
class AccountModel extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}