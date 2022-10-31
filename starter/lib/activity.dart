import 'package:flutter/material.dart';

/// Activity class that stores a title and possible image, description, and date
class Activity {
  Image? image;
  String title;
  String? description;
  DateTime? date;

  /// Activity constructor
  Activity({required this.title, this.description, this.image, this.date});

  /// returns the date in the format MM/DD/YYYY
  String getDateAsString() {
    String dateAsString = date.toString();
    return date == null
        ? ''
        : '${dateAsString.substring(5, 7)}/${dateAsString.substring(8, 10)}/${dateAsString.substring(0, 4)}';
  }
}
