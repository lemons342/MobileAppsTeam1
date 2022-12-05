import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart'
  hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'firebase_options.dart';


//Quick make of a way to have access to if the user is signed in or not across the app
class AccountModel extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

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
}