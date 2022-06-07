import 'package:flutter/material.dart';
import 'package:schedule_utm_driver/model/destination.dart';

class Timetable{
var timetable = {};//{'St. George':[Destination("St. George", TimeOfDay(hour: 5,minute: 15))], 'Sheridan': [Destination("St. George", TimeOfDay(hour: 8,minute: 15))]};
Timetable() {
  timetable["St. George"] = List.empty(growable: true);
  timetable["Sheridan"] = List.empty(growable: true);
 initializeTimetable();                                      
}                                                        // MON - THURS: 19:25, 20:25, 20:55, 21:55
  final today = DateTime.now();
  void initializeTimetable() {
    timetable["St. George"]!.clear();
    timetable["Sheridan"]!.clear();

      if(today.weekday<6){
        for(int i = 5; i < 23; i++){
        if(i>5 && i < 18 || i == 22){
          if(i>6 && i < 18){
            timetable["St. George"]!.add(Destination("St. George", TimeOfDay(hour: i,minute: 15)));

          }
          timetable["St. George"]!.add(Destination("St. George", TimeOfDay(hour: i,minute: 35)));

        }
        if(i > 17 && i < 22){
          if(today.weekday < 5 || (i != 19 && i!= 20)){
            timetable["St. George"]!.add(Destination("St. George", TimeOfDay(hour: i,minute: 25)));

          }
        }
        if((today.weekday < 5 && i < 22 )|| (i < 22)){
          timetable["St. George"]!.add(Destination("St. George", TimeOfDay(hour: i,minute: 55)));

        }
        }
      }else if(today.weekday == 6){
        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 8,minute: 0)));

        for(int i = 10; i < 14; i++){
          timetable["St. George"]!.add(Destination("St. George", TimeOfDay(hour: i,minute: 0)));

        }
        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 15,minute: 15)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 18,minute: 0)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 20,minute: 0)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 21,minute: 0)));

      }else{
        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 10,minute: 0)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 12,minute: 0)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 15,minute: 15)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 18,minute: 0)));

        timetable["St. George"]!.add(Destination("St. George", const TimeOfDay(hour: 20,minute: 0)));
      }
  }
  Destination getIndexDestination(String route, int index){
    // if(timetable[route] == null || index > timetable[route].length){
    //   return Destination("Empty", const TimeOfDay(hour: 10, minute: 10));
    // }
    return timetable[route].elementAt(index);
  }
  int getTimetableLength(String route){
    return timetable[route].length;
  }
}