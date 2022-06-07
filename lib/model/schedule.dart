import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schedule_utm_driver/model/destination.dart';

class Schedule extends ChangeNotifier{
final List<Destination> schedule = [];

void addDestination(Destination destination){
  destination.driver = FirebaseAuth.instance.currentUser!.email!;
  schedule.add(destination);
  notifyListeners();
}
void removeDestination(){
  if(schedule.length > 1){
  schedule.first.driver = "";
  schedule.removeAt(0);
  notifyListeners();
  }
}
void removethisDestination(Destination destination){
  if(schedule.isNotEmpty){
  schedule.elementAt(schedule.indexOf(destination)).driver = "";
  schedule.remove(destination);
  notifyListeners();
  }
}
Destination getCurrentDestination(){
  if(schedule.length>1){
  return schedule.first;
  }else{
  return Destination("Empty", TimeOfDay.now());
  }
}
bool containsDestination(Destination destination){
return schedule.contains(destination);
}
Destination getIndexDestination(int index){
  return schedule.elementAt(index);
}
int getLength(){
  return schedule.length;
}
}