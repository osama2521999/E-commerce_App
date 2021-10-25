
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'UI/admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      // initialRoute: String,
      routes: <String,WidgetBuilder>{
        '/Admin' : (BuildContext context)=>Admin(),
      },

      home: Admin(),
    );
  }
}



