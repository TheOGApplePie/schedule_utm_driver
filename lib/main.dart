import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:schedule_utm_driver/model/schedule.dart';
import 'screens/schedule_screen.dart';
import 'model/timetable.dart';
import 'screens/main_map_screen.dart';
import 'screens/auth_screen.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(create: (context) => Timetable()),
      // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<Timetable, Schedule>(
          create: (context) => Schedule(),
          update: (context, timetable, schedule) {
            if (schedule == null) throw ArgumentError.notNull('schedule');
            return schedule;
          },
        ),
    ], child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => gethome(),
        '/-auth':(context) => const AuthScreen(),
        '/-schedule':(context) => const ScheduleScreen()
      },
    ),);
    
  }
}

Widget gethome() {

  if(FirebaseAuth.instance.currentUser == null){
    return const AuthScreen();
  }
  return const MainMapScreen();
}
