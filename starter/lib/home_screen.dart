// ignore_for_file: slash_for_doc_comments

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account_model.dart';

/**
 * Name: Nick Lemerond
 * Date: 12//2022
 * Description: Provides a link to the user to open a webpage to the BBBS website. Shows
 *    the user their signed up activities
 * Bugs: None that I know of
 * Reflection: At first this used to just have the sign up ListTile but I took your suggestion 
 *    from class and added a bit more to the top to fill the space as you will see
 */

/// Home screen page
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.model}) : super(key: key);
  final AccountModel model;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 23, fontFamily: 'Montserrat');

  final TextStyle dateStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
  );

  final TextStyle descriptionStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');

    return StreamBuilder<QuerySnapshot>(
        stream: activities
            .where('signedUp', arrayContains: widget.model.GetUserEmail())
            .snapshots(),
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
                const Divider(color: Colors.grey, thickness: 1.0, height: 1.0),
                DecoratedBox( //Lines 61-96 are for the BBBS exerpt
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/bbbs_logo.png',
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          "Big Brothers Big Sisters helps children realize their potential and build their futures. We nurture children and strengthen communities. And we couldn't do any of it without you.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 200, 200, 200),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: _launchUrl,  //calls method to launch webapge to BBBS website
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFF00FC87),
                            ),
                            child: const Text('Learn More')),
                      )
                    ],
                  ),
                ),
                const Padding(  //Lines 97-113 are for the SIGNED UP ACTIVITIES decoration
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'SIGNED UP ACTIVITIES',
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
                      color: Color(0xFF00FC87), thickness: 4.0, height: 1.0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.separated(
                      itemCount: currentActivities.length,
                      itemBuilder: (context, index) { //itemBuilder populates ListTile with actvities/events pulled from the database that the user signed up for
                        var currentActivity =
                            currentActivities[index]; // the map stored in a QDS
                        return ListTile(
                          title: Text(currentActivity['title']),
                          subtitle: Text(currentActivity['date']),
                          trailing: IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => showDetailedInfo(
                                widget.model, context, currentActivity,
                                isSignedUp: true, isFavorited: false),
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
  /**
   * Method to launch the BBBS website
   */
  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://www.bbbs.org/about-us/');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
