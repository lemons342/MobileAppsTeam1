import 'package:flutter/material.dart';
import 'screen.dart';

void main() {
  runApp(MaterialApp(title: 'My App', home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Image.asset('assets/bbbs_logo.png', fit: BoxFit.cover),
          //titleSpacing: 50,
          toolbarHeight: 70,
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ScreenOne(),
          BottomAppBar(
            color: Colors.black,
            child: IconTheme(
              data:
                  const IconThemeData(
                      color: Color(0xFF00FC87),
                      size: 40,
                    ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Insert tip here',
                    icon: const Icon(Icons.volunteer_activism),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Insert tip here',
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Insert tip here',
                    icon: const Icon(Icons.home),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Insert tip here',
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
