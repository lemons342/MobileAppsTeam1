import 'package:flutter/material.dart';
import 'package:lab3/account.dart';
import 'package:lab3/activity.dart';
import 'package:lab3/createaccount.dart';
import 'package:lab3/home_screen.dart';
import 'package:lab3/login.dart';
import 'screen.dart';

void main() {
  runApp(const MaterialApp(title: 'FreeTime', home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  List<Widget> tabViews = [
    ActivityScreen(),
    const ScreenOne(),
    HomeScreen(),
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
          title: const Text('FreeTime'),  //Make this look better
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
            const Icon(Icons.exit_to_app) //Tried to change to IconButton but was invisible
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
                label: 'AcCount'),
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
