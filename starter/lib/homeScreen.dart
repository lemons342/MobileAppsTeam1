import 'package:flutter/material.dart';
import 'activity.dart';

/// Home screen page
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // list of user's activites (will be changed to pull from user's saved activities)
  final List<Activity> list = [
    Activity(
        title: 'EAA Aviation Museum',
        description:
            'Explore world-class displays and galleries of over 200 historic planes.'),
    Activity(
        title: 'Paine Art Center and Gardens',
        description:
            'Take a look at botainical gardens, classic European-style architecture, an extensive art collection, and more.',
        image: Image.asset('paine.png')),
    Activity(
        title: 'Oshkosh Public Museum',
        image: Image.asset('osh_pub_museum.png')),
    Activity(
        title: 'Oshkosh Earth Science Club Gem & Mineral Show',
        description:
            'Displays of rocks, minerals, fossils, and jewelry. Door prizes and raffles.',
        date: DateTime.now(),
        image: Image.asset('earth_science_club.png'))
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'SIGNED UP ACTIVITIES:',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                decoration: TextDecoration.underline),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(list[index].title),
                  subtitle: Text(list[index].description ?? ''),
                  leading: list[index].image,
                  trailing: Text(list[index].getDateAsString()),
                  contentPadding: const EdgeInsets.all(10.0),
                );
              },
              itemCount: list.length,
              separatorBuilder: (context, index) {
                return const Divider(
                    color: Colors.grey, thickness: 1.0, height: 1.0);
              },
            ),
          ),
        ),
      ],
    );
  }
}
