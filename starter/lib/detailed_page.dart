import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_model.dart';
import 'utils.dart';

class DetailedPage extends StatefulWidget {
  final QueryDocumentSnapshot activity;
  final bool withDeleteButton;
  final AccountModel model;

  const DetailedPage(
      {Key? key,
      required this.model,
      required this.activity,
      required this.withDeleteButton})
      : super(key: key);

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  final TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final IconButton button = widget
            .withDeleteButton // show add or delete button
        ? IconButton(
            onPressed: () {
              removeUserFromActivity(context, widget.model, widget.activity);
            },
            icon: const Icon(Icons.clear))
        : IconButton(
            onPressed: () {
              addUserToActivity(context, widget.model, widget.activity);
            },
            icon: const Icon(Icons.add));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          button,
        ],
      ),
      body: displayBodyWithData(context),
    );
  }

  /// widget to display in the main body
  /// only called when there is data received from a future
  Widget displayBodyWithData(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // take up 100% of width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(widget.activity['title'], // activity title
                style: titleStyle,
                textAlign: TextAlign.center),
          ),
          SizedBox(
            height: 100,
            child:
                Text(formatDateString(widget.activity['date']), // activity date
                    textAlign: TextAlign.center),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                    // activity description
                    widget.activity['description'] ?? '',
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDateString(String date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    DateTime dtDate =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    return '${months[dtDate.month - 1]} ${dtDate.day}, ${dtDate.year}';
  }
}
