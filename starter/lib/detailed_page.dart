import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'activity.dart';
import 'utils.dart';

class DetailedPage extends StatelessWidget {
  final int activityIndex; // change??
  final bool withDeleteButton;

  const DetailedPage(
      {Key? key, required this.activityIndex, required this.withDeleteButton})
      : super(key: key);

  final TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final IconButton button = withDeleteButton // show add or delete button
        ? IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
        : IconButton(onPressed: () {}, icon: const Icon(Icons.add));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
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
          var currentActivity = activityList[activityIndex];
          return SizedBox(
            width: MediaQuery.of(context).size.width, // take up 100% of width
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(currentActivity['title'], // activity title
                    style: titleStyle,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 100,
                  child:
                      Text(currentActivity['date'].toString(), // activity date
                          textAlign: TextAlign.center),
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        // activity description
                        currentActivity['description'] ?? '',
                        textAlign: TextAlign.center),
                  ],
                ),
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
}
