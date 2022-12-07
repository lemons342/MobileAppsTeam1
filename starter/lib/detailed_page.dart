import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
//import 'activity.dart';
import 'account_model.dart';
import 'account.dart';
import 'utils.dart';

class DetailedPage extends StatefulWidget {
  final int activityIndex; // change??
  final bool withDeleteButton;
  //final AccountModel model;

  const DetailedPage(
      {Key? key, required this.activityIndex, 
      //required this.model, 
      required this.withDeleteButton})
      : super(key: key);

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  final TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 40);

  final TextStyle dateStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

  final TextStyle descriptionStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final IconButton button = widget.withDeleteButton // show add or delete button
        ? IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
        : IconButton(onPressed: () {}, icon: const Icon(Icons.add));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Activity Details'),
        backgroundColor: Colors.black,
        actions: [
          button,
        ],
      ),
      body: createFutureBuilder(),
    );
  }

  /// creates the future builder to display the information received
  FutureBuilder<QuerySnapshot> createFutureBuilder() {
    return FutureBuilder<QuerySnapshot>(
      future: getAllActivities(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // waiting
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // an error
          return const Center(child: Text('Error'));
        } else if (snapshot.hasData) {
          // got data
          var activityList = snapshot.data!.docs;
          var currentActivity = activityList[widget.activityIndex];
          return Padding(
            padding: const EdgeInsets.all(15), 
            //alignment: Alignment.center, //default is center         
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(currentActivity['title'], // activity title
                    style: titleStyle,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 30,
                  child:
                      Text(checkDate(currentActivity['date']), // activity date
                          style: dateStyle,
                          textAlign: TextAlign.center),
                ),
                const Padding(padding: EdgeInsets.all(10),
                child: Divider(color: Colors.grey, thickness: 1.0, height: 1.0)),
                FractionallySizedBox(
                  widthFactor: 0.9, 
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  child:
                    Text(
                        // activity description
                        currentActivity['description'] ?? '',
                        style: descriptionStyle,
                        textAlign: TextAlign.center,
                        //maxLines: 15,
                        ),
                  
                ),
                Image.network(currentActivity['image'] ?? ''),
                // Row( //Should be a bottom nav bar for sign up and favorite
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   // ignore: prefer_const_literals_to_create_immutables
                //   children: [
                //     const IconButton(
                //       onPressed: null,//_addFavoriteActivities(activity: currentActivity), 
                //       icon: Text('Sign Up', textAlign: TextAlign.center),
                //       color: Colors.black, 
                //       ),
                //     const IconButton(
                //       onPressed: null,//_addSignedUpActivities(activity: currentActivity), 
                //       icon: Text('Favorite', textAlign: TextAlign.center),
                //       color: Colors.black, 
                //       ),
                //   ],
                // ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('This shouldn\'t happen'),
          );
        }
      },
    );
  }

  //Checks if there is a date for an activity
  String checkDate(String date) {
    if (date == '') {
      return '';
    } else {
      return DateFormat.yMMMMd().format(DateTime.parse(date));
    }
  }

  Future<void> _addFavoriteActivities({required String activity}) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(activity)
        .set({'favorited': null //widget.model.GetUserEmail()},
        }, 
        SetOptions(merge: true));
  }

  Future<void> _addSignedUpActivities({required String activity}) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(activity)
        .set({'signedUp': null //widget.model.GetUserEmail()},
        }, 
        SetOptions(merge: true));
  }
}
