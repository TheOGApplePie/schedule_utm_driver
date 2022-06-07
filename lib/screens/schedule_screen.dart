import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_utm_driver/model/schedule.dart';
import 'main_map_screen.dart';
import 'timetable_screen.dart';

// ignore: must_be_immutable
class ScheduleScreen extends StatelessWidget{
const ScheduleScreen({Key? key}):super(key: key);
    
@override
Widget build (BuildContext context){
  return Scaffold(
        appBar: AppBar(
          title: const Text("Driver Schedule"),
        ),
        body: Column(children: const [Text('Destination - Departure time'),Expanded(child: Padding(padding: EdgeInsets.all(32.0), child: ScheduleList(),),)],),
        drawer: Drawer(child: 
        ListView(padding: const EdgeInsets.all(20.0), children: [
          DrawerHeader(child: Text(FirebaseAuth.instance.currentUser!.email!)),
          ListTile(title: const Text('Main Screen'), 
          onTap:(){Navigator.pop(context);Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const MainMapScreen()));}
          ,),  ListTile(title: const Text('Edit Schedule'), onTap: (){
            Navigator.pop(context);Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const ScheduleScreen()));
          },
          )],
          ),
          ),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.edit), onPressed: (){
            Navigator.push<void>(context, MaterialPageRoute<void>(builder: (BuildContext context) => const RouteTimeTableScreen()));
            }),
    );
}
}

class ScheduleList extends StatelessWidget{
  const ScheduleList({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    // This gets the current state of Schedule and also tells Flutter
    // to rebuild this widget when Schedule notifies listeners (in other words,
    // when it changes).
    var schedule = context.watch<Schedule>();
    if(schedule.getLength() == 0){
      return const Text("No runs scheduled for you.\nTap the edit button to edit schedule.");
      }else{
    return ListView.builder(itemCount: schedule.getLength(), 
    itemBuilder: (BuildContext context, int index) => ListTile(
      title: Text(schedule.getIndexDestination(index).toString()),)
    );
    }
  }
}