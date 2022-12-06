import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils.dart';

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
  CollectionReference activities = FirebaseFirestore.instance.collection('activities');

  return FutureBuilder<QuerySnapshot>(future: activities.get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == 
                ConnectionState.waiting) { 
              return const Center(child: Text('Waiting')); 
            } else if (snapshot.hasError) { 
              return const Center(child: Text('Error')); 
            } else if (snapshot.hasData) { 
              List<QueryDocumentSnapshot> currentActivities = snapshot.data!.docs; // all docs
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
                itemCount: currentActivities.length,
                itemBuilder: (context, index) {
                  var currentActivity = currentActivities[index]; // the map stored in a QDS
                    return ListTile(
                    onTap: () => showDetailedInfo(context, index, isSignedUp: false),
                    title: Text(currentActivity['title']),
                    subtitle: Text(currentActivity['date']),
                    );
                },
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
                itemCount: currentActivities.length,
                itemBuilder: (context, index) {
                  var currentActivity = currentActivities[index]; // the map stored in a QDS
                    return ListTile(
                    title: Text(currentActivity['title']),
                    leading: Text(currentActivity['date']),
                    subtitle: Text(currentActivity['description']),
                    );
                },
                separatorBuilder: (context, index) {
                return const Divider(
                    color: Colors.grey, thickness: 1.0, height: 1.0);
              },
            ),
          ),
        ),
      ],
    );
            } else { 
              return const Center( 
                  child: Text('This probably won\'t be returned')); 
            } 
    }
  );
    
  }
  //unused function
  // Future<QuerySnapshot> _getActivities() async {
  //   // method will be changed to interact with the database to only
  //   // pull activities whose date matches the date in the parameter
  //   CollectionReference activities = FirebaseFirestore.instance.collection('activities');
  //   Future<QuerySnapshot> allActivities = activities.get();
  //   allActivities.then((querySnapshot) { 
  //     for (QueryDocumentSnapshot qds in querySnapshot.docs) { 
  //       Text('data: ${qds['title']}, ${qds['description']}, ${qds['date']}'); //unecessary
  //     } 
  //   });

  //   print('print');
  //   print(allActivities);
  //   return allActivities;
  // }
}
