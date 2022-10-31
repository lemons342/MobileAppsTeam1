import 'package:flutter/material.dart';
import 'package:lab3/homeScreen.dart';
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
    const ScreenOne(),
    const ScreenOne(),
    HomeScreen(),
    const ScreenOne()
  ];

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Image.asset('assets/bbbs_logo.png', fit: BoxFit.cover),
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
                tooltip: 'Insert tip here',
                backgroundColor: Colors.black,
                icon: Icon(Icons.volunteer_activism),
                label: ''),
            BottomNavigationBarItem(
                tooltip: 'Insert tip here',
                backgroundColor: Colors.black,
                icon: Icon(Icons.calendar_month),
                label: ''),
            BottomNavigationBarItem(
                tooltip: 'Home Screen',
                backgroundColor: Colors.black,
                icon: Icon(Icons.home),
                label: 'Home Screen'),
            BottomNavigationBarItem(
                tooltip: 'Insert tip here',
                backgroundColor: Colors.black,
                icon: Icon(Icons.settings),
                label: ''),
          ],
        ),
      ),
    );
  }
}
