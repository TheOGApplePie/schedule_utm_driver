import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/destination.dart';
import '../model/schedule.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'schedule_screen.dart';
var user = FirebaseAuth.instance.currentUser;
class MainMapScreen extends StatefulWidget {
  const MainMapScreen({ Key? key}) : super(key: key);
  
  @override
  _MainMapScreenState createState() => _MainMapScreenState();
}
var db = FirebaseFirestore.instance;
Schedule schedule = Schedule();
LatLng currentPosition = const LatLng(43.549131, -79.663648);
setValue(Position value) {
  currentPosition = LatLng(value.latitude, value.longitude);
}
class _MainMapScreenState extends State<MainMapScreen> {
  late GoogleMapController googleMapController;

  Future <void> _onMapCreated(GoogleMapController controller) async {
    _getUserLocation().then((value) =>  setValue(value)).then((value) => googleMapController.moveCamera(CameraUpdate.newLatLng(currentPosition)));
    googleMapController = controller;
    // Get data from firestore
    getDataFromFireStore();
    // Create Destination objects
    // Add Destination objects to Schedule object
  }

  Future <Position> _getUserLocation() async {
    bool servicesEnabled;
    LocationPermission permission;
    servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if(!servicesEnabled){
      return Future.error('Location Services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location Permissions are denied.');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
      }
  @override
  Widget build(BuildContext context) {
    const markerId =  MarkerId("Your Position");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UTM Shuttle Driver'),
          backgroundColor: Colors.blue[600],
          ),
          body: GoogleMap(
            markers: {Marker(markerId: markerId, position: currentPosition)},
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 16
              ),
          ),
          drawer: Drawer(child: 
        ListView(children: [
          DrawerHeader(child: Text(FirebaseAuth.instance.currentUser!.email!)),
          ListTile(title: const Text('Main Screen'), 
          onTap:(){Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const MainMapScreen()));}
          ,),  ListTile(title: const Text('Edit Schedule'), onTap: (){
            Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const ScheduleScreen()));
          },
          )],
          ),
          ),
      ),
    );
  }
  
  void getDataFromFireStore() {
    final toRef = db.collection("Routes").doc("Toronto").collection("Schedule");
    final scaffold = ScaffoldMessenger.of(context);
    var schedule = context.read<Schedule>();
        schedule.schedule.clear();
    toRef.get().then(
      (doc) {
        //' doc = QuerySnapshot<Map<String, dynamic>>'
        var map = doc.docs.asMap();
        for(int i = 0; i < doc.size;i++){
          var document = doc.docs.elementAt(i); // 06:55-07:55
          if(document['Driver'] == user!.email){
            int firstHr = map[i]!.id.substring(0,2) as int;
            int firstMin = map[i]!.id.substring(3,5) as int;
            int secondHr = map[i]!.id.substring(6,8) as int;
            int secondMin = map[i]!.id.substring(9) as int;
            schedule.addDestination(Destination('St. George',TimeOfDay(hour: firstHr, minute: firstMin)));
            schedule.addDestination(Destination('Mississauga',TimeOfDay(hour: secondHr, minute: secondMin)));

          }
        }
    },onError: (e) => scaffold.showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    )
    );
  }
}
