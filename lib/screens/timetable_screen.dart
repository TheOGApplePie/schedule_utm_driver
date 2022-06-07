import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:schedule_utm_driver/model/destination.dart';
import 'package:schedule_utm_driver/model/schedule.dart';
import 'package:schedule_utm_driver/screens/main_map_screen.dart';
import '../model/timetable.dart';

class RouteTimeTableScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
   const RouteTimeTableScreen({Key? key}) : super(key: key);

  //final String route;

  @override
  _RouteTimeTableState createState() => _RouteTimeTableState();
}
late int timetableCount;

class _RouteTimeTableState extends State<RouteTimeTableScreen> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'St. George'),
    Tab(text: 'Sheridan'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }
  get onChanged => null;
  @override
  Widget build(BuildContext context) {
        var timetable = context.read<Timetable>();

    return Scaffold(
      appBar: AppBar(title:const Text('Route Timetable Selection'), 
                     bottom: TabBar(indicatorColor:Colors.blue[700],
                     tabs: myTabs,controller: _tabController),
                     ),
      body:TabBarView(controller: _tabController,
                      children: myTabs.map((Tab tab) {
                        final String label = tab.text!;
                        timetableCount = timetable.timetable[label].length;
                        return CustomScrollView(
                          slivers: [
                            SliverList(delegate: SliverChildBuilderDelegate((context, index) => TimetableList(index, label), childCount: timetableCount))
                          ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.done), onPressed: (){
            Navigator.pop(context);
            }),
    );
  }
}

class TimetableList extends StatefulWidget{
  final int index;
  final String label;
  // ignore: use_key_in_widget_constructors
  const TimetableList(this.index, this.label);
  
  @override
  // ignore: no_logic_in_create_state
  TimetableListState createState() => TimetableListState(label, index);
}

  @override
  class TimetableListState extends State<TimetableList> {
    String label;
    int index;
    TimetableListState(this.label, this.index);
    bool isChecked = false;
    @override
  Widget build(BuildContext context) {

    var f = NumberFormat("00", "en_US");
    var destination = context.select<Timetable, Destination>(
      (timetable) {
           return timetable.getIndexDestination(label, index);
        }
    );
    var schedule = context.read<Schedule>();
    var mississaugaDue = TimeOfDay(hour: destination.getDue().hour+1, minute: destination.getDue().minute);
    var mississaugaDestination = Destination("Mississauga", mississaugaDue);
    if(schedule.containsDestination(destination)){
      isChecked = true;
    }
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Row(children: [
      Checkbox(value: isChecked, onChanged: (bool? value){
        setState(() {          
          isChecked = value!;
        });
        if(isChecked){
        schedule.addDestination(destination);
        schedule.addDestination(mississaugaDestination);
        }else{
          schedule.removethisDestination(destination);
          schedule.removethisDestination(mississaugaDestination);
        }
      }), 
      Text('${f.format(destination.getDue().hour)}:${f.format(destination.getDue().minute)}/${f.format((destination.getDue().hour+1)%24)}:${f.format(destination.getDue().minute)}'),
      ],
      ),
      );
  }
  }

