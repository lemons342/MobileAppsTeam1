import 'package:firebase_core/firebase_core.dart';
import 'package:lab3/createaccount.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'account.dart';
import 'activity.dart';
import 'calendar.dart';
import 'home_screen.dart';
import 'login.dart';
import 'account_model.dart';

//Connecting to database before running appp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'finalproject-team1',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => AccountModel(),
      child: MaterialApp(
        title: 'FreeTime',
        home: const MyApp(),
        routes: {
          '/home': (context) {
            return const HomeScreen();
          },
          '/register': ((context) {
            return Consumer<AccountModel>(builder: (context, model, child) {
              return CreateAccount(model: model);
            });
          }),
        },
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 4; //default index to start at homescreen

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
      builder: (context, model, child) {
        List<Widget> tabViews = [
          //list of calls to screens
          const ActivityScreen(),
          const Calendar(),
          const HomeScreen(),
          Account(model: model),
          Login(
            model: model,
          )
        ];

        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: Colors.black,
              title: const Text('FreeTime'), //Make this look better
              actions: [
                SizedBox(
                  //title bar(top of screen)
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
              toolbarHeight: 70,
            ),
            body: tabViews[selectedIndex], //call to view depending on index
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              selectedIconTheme:
                  const IconThemeData(color: Color(0xFF00FC87), size: 40),
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.black,
              onTap: _handleTap,
              items: const [
                //*** temporary tabs for login and create account
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
                    tooltip: 'Login',
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.settings),
                    label: 'Login'),
              ],
            ),
          ),
        );
      },
    );
  }
}
