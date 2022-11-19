import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab3/activity.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:lab3/home_screen.dart'; // remove once using database

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
  }) : super(key: key);

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
  DateTime? _firstDay;
  DateTime? _lastDay;
  DateTime? _selectedDay;

  List<Activity> activities = [];

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
              activities = _getEventsForDay(selectedDay);
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
          eventLoader: (day) => _getEventsForDay(day),
        ),
        divider,
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                    title: Text(activities[index].title),
                  ),
              separatorBuilder: (context, index) => divider,
              itemCount: activities.length),
        )
      ],
    );
  }

  /// Configures the starting and ending dates for the calendar range
  void _configureStartAndEndDates() {
    _firstDay = DateTime.utc(
        (_focusedDay.month - 3) < 1 // if month number is less than 1
            ? _focusedDay.year - 1 // decrement to previous year
            : _focusedDay.year, // year stays the same
        (_focusedDay.month - 3) < 0
            ? (_focusedDay.month - 3) + 12
            : _focusedDay.month - 3,
        30);
    _lastDay = DateTime.utc(
        (_focusedDay.month + 3) / 12 > 0 // if month number exceeds 12
            ? _focusedDay.year + 1 // increment to next year
            : _focusedDay.year, // year stays the same
        (_focusedDay.month + 3) % 12,
        30);
  }

  /// Gets the activities for the given [day]
  /// (Will be implemented to pull from database)
  List<Activity> _getEventsForDay(DateTime day) {
    // method will be changed to interact with the database to only
    // pull activities whose date matches the date in the parameter
    final allActivities = FirebaseFirestore.instance.collection('testCollection');
    List<Activity> validActivities = [];
    var query = allActivities.where('title', isEqualTo: "working");
    query.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {   //setstate????
          Activity currentActivity = Activity(
              title: doc['title'],
              description: doc['description'],
              date: doc['date']);
          validActivities.add(currentActivity);
          // ignore: avoid_print
          print(currentActivity.toString());
        });
      }
    });

    // List<Activity> activities = HomeScreen().list;
    // for (var element in activities) {
    //   if (isSameDay(element.date, day)) {
    //     validActivities.add(element);
    //   }
    // }
    return validActivities;
  }
}
