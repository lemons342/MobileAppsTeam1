import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'account.dart';
import 'activity.dart';
import 'calendar.dart';
import 'createaccount.dart';
import 'home_screen.dart';
import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'finalproject-team1',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(title: 'FreeTime', home: MyApp()));
  // if (Firebase.apps.isEmpty) {
  //    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // }else {
  //    Firebase.app(); // if already initialized, use that one
  // }
  
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 2;
  List<Widget> tabViews = [
    const ActivityScreen(),
    const Calendar(),
    const HomeScreen(),
    Account(),
    const CreateAccount(),
    const Login()
  ];

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: const Text('FreeTime'), //Make this look better
          actions: [
            SizedBox(
              width: 200,
              child: Image.asset(
                'assets/bbbs_logo.png',
              ),
            ),
            // const IconButton(
            //   onPressed: null,
            //   icon: Icon(Icons.exit_to_app),
            // ),
            const Icon(Icons
                .exit_to_app) //Tried to change to IconButton but was invisible
          ],
          //titleSpacing: 50,
          toolbarHeight: 70,
        ),
        body: tabViews[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedIconTheme:
              const IconThemeData(color: Color(0xFF00FC87), size: 40),
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          onTap: _handleTap,
          items: const [
            BottomNavigationBarItem(
                tooltip: 'Activities',
                backgroundColor: Colors.black,
                icon: Icon(Icons.volunteer_activism),
                label: 'Activities'),
            BottomNavigationBarItem(
                tooltip: 'Calendar',
                backgroundColor: Colors.black,
                icon: Icon(Icons.calendar_month),
                label: 'Calendar'),
            BottomNavigationBarItem(
                tooltip: 'Home Screen',
                backgroundColor: Colors.black,
                icon: Icon(Icons.home),
                label: 'Home Screen'),
            BottomNavigationBarItem(
                tooltip: 'Account',
                backgroundColor: Colors.black,
                icon: Icon(Icons.person),
                label: 'Account'),
            BottomNavigationBarItem(
                tooltip: 'Create Account',
                backgroundColor: Colors.black,
                icon: Icon(Icons.person_add),
                label: 'Create Account'),
            BottomNavigationBarItem(
                tooltip: 'Login',
                backgroundColor: Colors.black,
                icon: Icon(Icons.settings),
                label: 'Login'),
          ],
        ),
      ),
    );
  }
}
