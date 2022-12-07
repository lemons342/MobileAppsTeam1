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
  String getDateAsString() { //used in calendar
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
  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

  return FutureBuilder<QuerySnapshot>(future: activities.get(), //calling all activities from Firebase
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
                  // if (checkDate(currentActivity['date']) == true) {
                    return ListTile(
                      onTap: () => showDetailedInfo(context, index, isSignedUp: false),
                      title: Text(currentActivity['title']),
                      subtitle: Text(currentActivity['description'], maxLines: 2),
                    );
                  // } else {
                  //   return Text('Error');
                  // }
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
                      onTap: () => showDetailedInfo(context, index, isSignedUp: false),
                      title: Text(currentActivity['title']),
                      leading: Text(currentActivity['date']),
                      subtitle: Text(currentActivity['description'], maxLines: 2),
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
