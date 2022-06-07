import 'package:flutter/material.dart';

class Destination{
  String place = "Mississauga";
  TimeOfDay due = const TimeOfDay(hour: 15, minute: 35);
  String driver = "";
  Destination(this.place, this.due);

  TimeOfDay getDue(){return due;}
  String getPlace(){return place;}
  String getDriver(){return driver;}

  @override
  String toString() {
    return '$place - ${due.hour}:${due.minute}';
  }
}