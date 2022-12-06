import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

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
  DateTime _selectedDay = DateTime.now();

  List<Activity> activities = [];

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
          //eventLoader: (day) => _getEventsForDay(day),
        ),
        divider,
        
        FutureBuilder(
          future: _getEventsForDay(day: _selectedDay),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Waiting'));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> currentActivities =
                snapshot.data!.docs; // all docs
            return
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.separated(
                      itemCount: currentActivities.length,
                      itemBuilder: (context, index) {
                        var currentActivity =
                            currentActivities[index]; // the map stored in a QDS
                        return ListTile(
                          onTap: () => showDetailedInfo(context, index, isSignedUp: true),
                          title: Text(currentActivity['title']),
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
          }  },
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

  Future<QuerySnapshot> _getEventsForDay({required DateTime day}){
    String date = '${day.year}-';
    if(day.month >= 10){
      date += '${day.month}-';
    }else{
      date += '0${day.month}-';
    }
    if(day.day >= 10){
      date += '${day.day}';
    }else{
      date += '0${day.day}';
    }
    return FirebaseFirestore.instance
        .collection('activities')
        .where('date', isEqualTo: date)
        .get();
  }
/*
  /// Gets the activities for the given [day]
  List<Activity> _getEventsForDay(DateTime day) {
    // pull activities whose date matches the date in the parameter
    final allActivities = FirebaseFirestore.instance.collection('activities');
    List<Activity> validActivities = [];
    var formattedDay = day.toString().substring(0, 10);
    var query = allActivities.where('date', isEqualTo: formattedDay);
    query.get().then((querySnapshot) {
      //setState(() {
        for (var doc in querySnapshot.docs) {
        Activity currentActivity = Activity(
            title: doc['title'],
            description: doc['description'],
            date: DateTime.parse(doc['date']));
        validActivities.add(currentActivity);
      }
      //});
      
    });

    return validActivities;
  }
  */
}
