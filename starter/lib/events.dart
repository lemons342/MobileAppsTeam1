// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils.dart';
import 'account_model.dart';

/**
 * Name: Nick Lemerond
 * Date: 12//2022
 * Description: Pretty much a copy and paste with the activity 
 *    page but formatting the ListTile with dates in the leading
 * Bugs: None that I know of
 * Reflection: Pretty straight forward, not much issues
 */

Widget printDate(String date, TextStyle style) { //Sets print layout of date in ListTile
  String monthDay = date.substring(5,10); 
  String year = date.substring(0,4);  //for date formatting

  if (monthDay[0] == '0') { //cutting out leading '0'
    monthDay = date.substring(6,10);
  }

  return Column(
    children: [
      Text(monthDay, style: style, ),
      Text(year, style: style, ),
    ],
  );
}

class EventScreen extends StatefulWidget {
  final AccountModel model;

  const EventScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  //Text styles
  final TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Montserrat');

  final TextStyle dateStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 16,);

  final TextStyle descriptionStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 16,);
  
  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

    return FutureBuilder<QuerySnapshot>(
        future: activities.where('date', isNotEqualTo: '').get(), //calling all activities from Firebase that have dates
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
                const Padding( //Lines 70-87 are just for the EVENTS title decoration
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'EVENTS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Divider(
                                color: Color(0xFF00FC87), thickness: 4.0, height: 1.0
                                ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.separated(
                      itemCount: currentActivities.length,
                      itemBuilder: (context, index) { //itemBuilder populates ListTile with events pulled from the database
                        var currentActivity =
                            currentActivities[index]; // the map stored in a QDS
                        return ListTile(
                          title: Text(
                            currentActivity['title'], // activity title
                            style: titleStyle,
                          ),
                          minLeadingWidth: 60,  //sets minimum width of leading                       
                          leading: printDate(
                            currentActivity['date'], // activity date
                            dateStyle,//
                          ),
                          subtitle: Text(
                            currentActivity['description'], // activity description
                            style: descriptionStyle,
                            maxLines: 2,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => showDetailedInfo(  //opens Activity Details page with selected event
                              widget.model, context, currentActivity,
                              isSignedUp: false, isFavorited: false
                            ),
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
}
