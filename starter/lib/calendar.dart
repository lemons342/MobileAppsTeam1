import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';
import 'account_model.dart';

/// Name: Stephanie Amundson, Nick Lemerond
/// Date: 12/13/2022
/// Description: Calendar page that uses a calendar widget from pub.dev. The
///              top half is an interactive calendar and the bottom half is
///              a list view of all activities for the day selected
/// Bugs: Marker on a date only shows up if you click on a day. Probably has
///       something to do with _getEventsForDayForDisplay not getting called
///       right away/when the page updates.
/// Reflection: This page was probably the hardest page on the app to complete.
///             It was hard to get things to work exactly how I wanted them to
///             but I'm pretty happy with how it turned out.

class Calendar extends StatefulWidget {
  final AccountModel model;

  const Calendar({Key? key, required this.model}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var divider = const Divider(
    height: 1.0,
    thickness: 1.0,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _firstDay;
  DateTime? _lastDay;

  Map<DateTime, List<Activity>> activities = {};

  final headerStyle = const HeaderStyle(
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 21.0, color: Colors.white),
    decoration: BoxDecoration(color: Colors.black),
    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
    formatButtonTextStyle: TextStyle(fontWeight: FontWeight.bold),
    formatButtonDecoration: BoxDecoration(
        color: Color(0xFF00FC87),
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
  );

  final calendarStyle = const CalendarStyle(
    tablePadding: EdgeInsets.fromLTRB(0.2, 15, 0.2, 10),
    markerSize: 5,
    markerMargin: EdgeInsets.symmetric(horizontal: 0.5),
    selectedTextStyle:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    selectedDecoration:
        BoxDecoration(color: Color(0xFF00FC87), shape: BoxShape.circle),
    todayTextStyle: TextStyle(color: Colors.black),
    todayDecoration: BoxDecoration(
        color: Color.fromARGB(100, 0, 252, 134), shape: BoxShape.circle),
  );

  final TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Montserrat');

  final TextStyle dateStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 20,
  );

  final TextStyle descriptionStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  /// Imported calendar widget from api
  @override
  Widget build(BuildContext context) {
    _configureStartAndEndDates();

    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: _firstDay!,
          lastDay: _lastDay!,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
              //activities = _getEventsForDay(_selectedDay!);
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: calendarStyle,
          headerStyle: headerStyle,
          eventLoader: (day) {
            _getEventsForDayForDisplay(day);
            return activities[day] ?? [];
          },
        ),
        divider,
        FutureBuilder(
          future: _getEventsForDay(day: _selectedDay),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else if (snapshot.hasData) {
              List<QueryDocumentSnapshot> currentActivities =
                  snapshot.data!.docs; // all docs
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    itemCount: currentActivities.length,
                    itemBuilder: (context, index) {
                      var currentActivity =
                          currentActivities[index]; // the map stored in a QDS
                      return ListTile(
                        title:
                            Text(currentActivity['title'], style: titleStyle),
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
              );
            } else {
              return const Center(
                  child: Text('This probably won\'t be returned'));
            }
          },
        )
      ],
    );
  }

  /// Configures the starting and ending dates for the calendar range
  /// (previous 3 months to next 12 months from current date)
  void _configureStartAndEndDates() {
    var today = DateTime.now();
    // start at 3 months prior to today's date
    _firstDay = DateTime((today.month - 3 < 1) ? today.year - 1 : today.year,
        (today.month - 3) + 12 % 12, 1);

    // ends 12 months after today's date
    _lastDay = (today.month < 12)
        ? DateTime(today.year, today.month + 12, 0)
        : DateTime(today.year + 2, 1, 0);
  }

  /// gets the events for the given [day]
  Future<QuerySnapshot> _getEventsForDay({required DateTime day}) {
    // make sure the date is formatted correctly for querying
    String date = '${day.year}-';
    if (day.month >= 10) {
      date += '${day.month}-';
    } else {
      date += '0${day.month}-';
    }
    if (day.day >= 10) {
      date += '${day.day}';
    } else {
      date += '0${day.day}';
    }
    date = date.substring(0,10);
    return FirebaseFirestore.instance
        .collection('activities')
        .where('date', isEqualTo: date)
        .get();
  }

  /// Gets the activities for the given [day]
  /// (used by the event loader)
  List<Activity> _getEventsForDayForDisplay(DateTime day) {
    List<Activity> validActivities = [];

    var events = _getEventsForDay(day: day);

    events.then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Activity currentActivity = Activity(
            title: doc['title'],
            description: doc['description'],
            date: DateTime.parse(doc['date']));
        //print(currentActivity.date);
        validActivities.add(currentActivity);
      }
    });

    //for (var doc in events.docs) {
    //  Activity currentActivity = Activity(
    //      title: doc['title'],
    //      description: doc['description'],
    //      date: DateTime.parse(doc['date']));

    //  validActivities.add(currentActivity);
    //}

    activities.putIfAbsent(day, () => validActivities);
    //activities.update(day, (value) => validActivities);

    return validActivities;
  }
}
