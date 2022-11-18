import 'package:flutter/material.dart';

/// Activity class that stores a title and possible image, description, and date
class Activity {
  Image? image;
  String title;
  String? description;
  DateTime? date;

  /// Activity constructor
  Activity({required this.title, this.description, this.image, this.date});

  @override
  String toString() {
    return '$title, $description, $date';
  }

  /// returns the date in the format MM/DD/YYYY
  String getDateAsString() {
    String dateAsString = date.toString();
    return date == null
        ? ''
        : '${dateAsString.substring(5, 7)}/${dateAsString.substring(8, 10)}/${dateAsString.substring(0, 4)}';
  }
}

class ActivityScreen extends StatelessWidget {
  ActivityScreen({Key? key}) : super(key: key);

  // list of user's activites (will be changed to pull from user's saved activities)
  final List<Activity> openList = [
    Activity(
        title: 'EAA Aviation Museum',
        description:
            'Explore world-class displays and galleries of over 200 historic planes.'),
    Activity(
        title: 'Paine Art Center and Gardens',
        description:
            'Take a look at botainical gardens, classic European-style architecture, an extensive art collection, and more.',
        image: Image.asset('assets/paine.png')),
    Activity(
        title: 'Oshkosh Public Museum',
        image: Image.asset('assets/osh_pub_museum.png')),
    Activity(
        title: 'Oshkosh Earth Science Club Gem & Mineral Show',
        description:
            'Displays of rocks, minerals, fossils, and jewelry. Door prizes and raffles.',
        date: DateTime.now(),
        image: Image.asset('assets/earth_science_club.png'))
  ];

  final List<Activity> upcomingList = [
    Activity(
      title: 'EAA Airventure',
      image: Image.asset('assets/airventure.jpg'),
      description:
          'Don\'t miss your chance to celebrate aviation in the most epic way possible at EAA AirVenture!',
      date: DateTime(2023, 7, 24),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'OPEN ACTIVITIES', //Make this look better!
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
                  title: Text(openList[index].title),
                  subtitle: Text(openList[index].description ?? ''),
                  leading: openList[index].image,
                  trailing: Text(openList[index].getDateAsString()),
                  contentPadding: const EdgeInsets.all(10.0),
                );
              },
              itemCount: openList.length,
              separatorBuilder: (context, index) {
                return const Divider(
                    color: Colors.grey, thickness: 1.0, height: 1.0);
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'UPCOMING ACTIVITIES', //Make this look better!
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
                  title: Text(upcomingList[index].title),
                  subtitle: Text(upcomingList[index].description ?? ''),
                  leading: upcomingList[index].image,
                  trailing: Text(upcomingList[index].getDateAsString()),
                  contentPadding: const EdgeInsets.all(10.0),
                );
              },
              itemCount: upcomingList.length,
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
