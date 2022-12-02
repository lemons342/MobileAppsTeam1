import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // list of user's activites (will be changed to pull from user's saved activities)
  // final List<Activity> openList = [
  //   Activity(
  //       title: 'EAA Aviation Museum',
  //       description:
  //           'Explore world-class displays and galleries of over 200 historic planes.'),
  //   Activity(
  //       title: 'Paine Art Center and Gardens',
  //       description:
  //           'Take a look at botainical gardens, classic European-style architecture, an extensive art collection, and more.',
  //       image: Image.asset('assets/paine.png')),
  //   Activity(
  //       title: 'Oshkosh Public Museum',
  //       image: Image.asset('assets/osh_pub_museum.png')),
  //   Activity(
  //       title: 'Oshkosh Earth Science Club Gem & Mineral Show',
  //       description:
  //           'Displays of rocks, minerals, fossils, and jewelry. Door prizes and raffles.',
  //       date: DateTime.now(),
  //       image: Image.asset('assets/earth_science_club.png'))
  // ];

  // final List<Activity> upcomingList = [
  //   Activity(
  //     title: 'EAA Airventure',
  //     image: Image.asset('assets/airventure.jpg'),
  //     description:
  //         'Don\'t miss your chance to celebrate aviation in the most epic way possible at EAA AirVenture!',
  //     date: DateTime(2023, 7, 24),
  //   ),
  // ];

  
  

  @override
  Widget build(BuildContext context) {

    List<Activity> activities = _getActivities();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'OPEN ACTIVITIES', 
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
                return ListTile(  //Displays activities that are available to do
                  title: Text(activities[index].title),
                  subtitle: Text(activities[index].description ?? ''),
                  leading: activities[index].image,
                  trailing: Text(activities[index].getDateAsString()),
                  contentPadding: const EdgeInsets.all(10.0),
                );
              },
              itemCount: activities.length,
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
            'UPCOMING ACTIVITIES', 
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
                return ListTile( //Displays activities that are time sensitive and coming up
                  title: Text(activities[index].title),
                  subtitle: Text(activities[index].description ?? ''),
                  leading: activities[index].image,
                  trailing: Text(activities[index].getDateAsString()),
                  contentPadding: const EdgeInsets.all(10.0),
                );
              },
              itemCount: activities.length,
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

  List<Activity> _getActivities() {
    // method will be changed to interact with the database to only
    // pull activities whose date matches the date in the parameter
    final allActivities = FirebaseFirestore.instance.collection('activities');
    List<Activity> validActivities = [];
    var query = allActivities;
    query.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {   //setstate????
          Activity currentActivity = Activity(
              title: doc['title'],
              description: doc['description'],
              date: doc['date']);
          validActivities.add(currentActivity);
          // ignore: avoid_print
          print(currentActivity.toString());
        });
      }
    });

    // List<Activity> activities = HomeScreen().list;
    // for (var element in activities) {
    //   if (isSameDay(element.date, day)) {
    //     validActivities.add(element);
    //   }
    // }
    return validActivities;
  }
}
