import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async'; 
import 'activity.dart';

/// Home screen page
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of user's activites (will be changed to pull from user's saved
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
                itemCount: currentActivities.length,
                itemBuilder: (context, index) {
                  var currentActivity = currentActivities[index]; // the map stored in a QDS
                    return ListTile(
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
  Future<QuerySnapshot> _getActivities() async {
    // method will be changed to interact with the database to only
    // pull activities whose date matches the date in the parameter
    CollectionReference activities = FirebaseFirestore.instance.collection('activities');
    Future<QuerySnapshot> allActivities = activities.get();
    allActivities.then((querySnapshot) { 
      for (QueryDocumentSnapshot qds in querySnapshot.docs) { 
        Text('data: ${qds['title']}, ${qds['description']}, ${qds['date']}'); //unecessary
      } 
    });

    print('print');
    print(allActivities);
    return allActivities;
  }
}
