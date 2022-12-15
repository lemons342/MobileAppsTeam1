import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils.dart';
import 'account_model.dart';

/// Name: Stephanie Amundson 
/// Date: 12/13/2022
/// Description: Activity object for the app. Each activity has a title, and
///              and possible image, description, and date 
/// Bugs: None that I know of
/// Reflection: Implementing was pretty straightforward

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
    //used in calendar
    String dateAsString = date.toString();
    return date == null
        ? ''
        : '${dateAsString.substring(5, 7)}/${dateAsString.substring(8, 10)}/${dateAsString.substring(0, 4)}';
  }
}

/// Name: 
/// Date: 12//2022
/// Description: 
/// Bugs: None that I know of
/// Reflection: 


class ActivityScreen extends StatefulWidget {
  final AccountModel model;

  const ActivityScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat');

  final TextStyle dateStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 18,
  );

  final TextStyle descriptionStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

    return FutureBuilder<QuerySnapshot>(
        future: activities
            .where('date', isEqualTo: '')
            .get(), //calling all activities from Firebase
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> currentActivities =
                snapshot.data!.docs; // all docs
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'ACTIVITIES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      //decoration: TextDecoration.underline
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Divider(
                      color: Color(0xFF00FC87), thickness: 4.0, height: 1.0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.separated(
                      itemCount: currentActivities.length,
                      itemBuilder: (context, index) {
                        var currentActivity =
                            currentActivities[index]; // the map stored in a QDS
                        return ListTile(
                          title: Text(
                            currentActivity['title'], // activity title
                            style: titleStyle,
                          ),
                          subtitle: Text(
                            currentActivity['description'], // activity title
                            style: descriptionStyle,
                            maxLines: 2,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => showDetailedInfo(
                                widget.model, context, currentActivity,
                                isSignedUp: false, isFavorited: false),
                          ),
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
        });
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
