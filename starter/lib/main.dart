// ignore_for_file: slash_for_doc_comments

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'createaccount.dart';
import 'activity.dart';
import 'calendar.dart';
import 'home_screen.dart';
import 'login.dart';
import 'account_model.dart';
import 'events.dart';

/**
 * Name: 
 * Date: 12//2022
 * Description: 
 * Bugs: None that I know of
 * Reflection: 
 */

//Connecting to database before running app
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
        theme: ThemeData(fontFamily: 'Montserrat'),
        routes: {
          '/register': ((context) {
            return Consumer<AccountModel>(builder: (context, model, child) {
              return CreateAccount(model: model);
            });
          }),
        })
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 3; //default index to start at learn more/signed up

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final TextStyle titleStyle = const TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 2);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
      builder: (context, model, child) {
        List<Widget> tabViews = [   //list of calls to screens
          ActivityScreen(model: model),
          EventScreen(model: model),
          Calendar(model: model),
          HomeScreen(
            model: model,
          ),
          Login(
            model: model,
          )
        ];

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              title:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.square(
                        dimension: 50,
                        child: Image.asset('assets/freetime_logo.png'), //Logo image
                        ),
                      Text('FreeTime', style: titleStyle), //FreeTime title
                    ],
                  ), 
              toolbarHeight: 70,
            ),
            body: tabViews[selectedIndex], //call to view depending on index
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              selectedIconTheme:
                  const IconThemeData(color: Color(0xFF00FC87), size: 30),
              unselectedItemColor: Colors.white,
              //unselectedLabelStyle: TextStyle(overflow: TextOverflow.visible),
              //showUnselectedLabels: true,
              backgroundColor: Colors.black,
              onTap: _handleTap,
              items: const [
                BottomNavigationBarItem(
                    tooltip: 'Activities',
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.volunteer_activism),
                    label: 'Activities'),
                BottomNavigationBarItem(
                    tooltip: 'Events',
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.local_activity),
                    label: 'Events'),
                BottomNavigationBarItem(
                    tooltip: 'Calendar',
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.calendar_month),
                    label: 'Calendar'),
                BottomNavigationBarItem(
                    tooltip: 'Your Activities',
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.format_list_bulleted),
                    label: 'Your Activities'),
                BottomNavigationBarItem(
                    tooltip: 'Account',
                    backgroundColor: Colors.black,
                    icon: Icon(Icons.settings),
                    label: 'Account'),
              ],
            ),
          ),
        );
      },
    );
  }
}
