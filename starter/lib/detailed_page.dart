import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_model.dart';
import 'utils.dart';

class DetailedPage extends StatefulWidget {
  final QueryDocumentSnapshot activity;
  final bool withDeleteButton;
  //final bool withRemoveButton;
  final AccountModel model;

  const DetailedPage(
        {Key? key,
        required this.model,
        required this.activity,
        required this.withDeleteButton,
        //required this.withRemoveButton
        }
      )
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
    final OutlinedButton signUpButton = widget
            .withDeleteButton // show add or delete signUpButton
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 1), 
            ),
            onPressed: () {
              removeUserFromSignup(context, widget.model, widget.activity);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white)))
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 1), 
            ),
            onPressed: () {
              signUpForActivity(context, widget.model, widget.activity);
            },
            child: const Text('Sign Up', style: TextStyle(color: Colors.white)));

    final IconButton favoriteButton = widget
            .withDeleteButton // show add or delete button
        ? IconButton(
            onPressed: () {
              removeUserFavorite(context, widget.model, widget.activity);
            },
            icon: const Icon(Icons.favorite))
        : IconButton(
            onPressed: () {
              favoriteActivity(context, widget.model, widget.activity);
            },
            icon: const Icon(Icons.favorite));
            
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Activity Details'),
        backgroundColor: Colors.black,
        actions: [
          favoriteButton,
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
            child: signUpButton,
          ),
        ],
      ),
      body: displayBodyWithData(context),
    );
  }

  /// widget to display in the main body
  /// only called when there is data received from a future
  Widget displayBodyWithData(BuildContext context) {
  String image = '';
  try {
    image = widget.activity['image'];
  } catch (e) {
    print('Error: no image');
  }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(widget.activity['title'], // activity title
                style: titleStyle,
                textAlign: TextAlign.center),
          ),
          printDate(formatDateString(widget.activity['date'])),
          const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Divider(
                            color: Color(0xFF00FC87), thickness: 3.0, height: 1.0
                            ),
              ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    // activity description
                    widget.activity['description'] ?? '',
                    textAlign: TextAlign.center,
                    style: descriptionStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/$image',
                  errorBuilder: (context, error, stackTrace) {
                    print('Error: no image');
                    return const Padding(padding: EdgeInsets.all(0)); //if image is '', return widget taking up no space
                  },
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDateString(String date) {
    if (date.isEmpty) {
      return '';
    }
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

  Widget printDate (String date) {
    if (date != '') {
      return Text(date, // activity date
              textAlign: TextAlign.center,
              style: dateStyle);
    } else {
      return const Padding(padding: EdgeInsets.all(0)); //if date is '', return widget taking up no space
    }
  }
}
